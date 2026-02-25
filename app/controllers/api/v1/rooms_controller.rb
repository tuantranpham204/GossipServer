class Api::V1::RoomsController < ApplicationController
  include Api::V1::NotificationConcern

  def show_private
    status = params[:status]
    if [ "accepted", "pending", "declined" ].include?(status)
      error(message: I18n.t("errors.invalid_relation_type"), status: :unprocessable_content)
      return
    end
    room_type = status == "accepted" ? :private_strangers : "private_strangers_#{status}"
    @rooms = Room.where(room_type: room_type, participants: { user_id: current_user.id }).page(params[:page]).per(params[:per_page])
    authorize @rooms, :show_private?, policy_class: Api::V1::RoomPolicy
    if @rooms
      paginate(
        data: @rooms.each do | room |
          { **room.as_json,
            opponent:
            @room.participants.each do | participant |
              if participant.user_id != current_user.id
                opponent_profile = Profile.find_by(user_id: participant.user_id)
                { **participant.as_json,
                  avatar: opponent_profile.avatar_url,
                  name: opponent_profile.name,
                  surname: opponent_profile.surname,
                  username: opponent_profile.username
                }
              end
            end
          }
        end,
        meta: {
          total_pages: @rooms.total_pages,
          current_page: @rooms.current_page,
          per_page: params[:per_page] || 10,
          total_count: @rooms.total_count
        }
      )
    else
      error(message: I18n.t("errors.resource_not_found", resource: "Room"), status: :not_found)
    end
  end

  def request_private
    if UserRelation.find_by(requester_id: current_user.id, receiver_id: params[:receiver_id], relation_type: :friend, status: :accepted)
      room_type = :private_friends
    else
      room_type = :private_strangers_pending
    end
    @room = Room.create(room_type: room_type)
    authorize @room, :request_private?, policy_class: Api::V1::RoomPolicy
    if room_type == :private_strangers_pending
      create_notification(
        actor_id: current_user.id,
        user_id: params[:receiver_id],
        notification_type: :private_strangers_room_request,
        content: { "room_id": @room.id }
      )
    end
    participant1 = Participant.create(
      room_id: @room.id, user_id: current_user.id,
      role: room_type == :private_friends ? :private_friends : :private_strangers)
    participant2 = Participant.create(room_id: @room.id, user_id: params[:receiver_id],
      role: room_type == :private_friends ? :private_friends : :private_strangers)
    succeed(data:
    { **@room.as_json,
      participants: [ participant1, participant2 ]
    }, message: I18n.t("success.room_requested"))
  end

  def accept_private
    @room = Room.find(params[:room_id])
    authorize @room, :accept_private?, policy_class: Api::V1::RoomPolicy
    if !@room
      error(message: I18n.t("errors.resource_not_found", resource: "Room"), status: :not_found)
      return
    end
    is_current_user_participant = false
    @room.participants.each do | participant |
      if participant.user_id == current_user.id
        is_current_user_participant = true
        break
      end
    end
    if !is_current_user_participant
      error(message: I18n.t("errors.user_not_participant", resource: "Room"), status: :unauthorized)
      return
    end
    if [ :private_strangers_pending, :private_strangers_declined ].include?(@room.room_type.to_sym)
      if @room.update(room_type: :private_strangers)
        succeed(message: I18n.t("success.room_accepted"))
      else
        error(message: I18n.t("errors.update_failure", resource: "Room"), status: :unprocessable_content)
      end
    else
      error(message: I18n.t("errors.only_pending_updatable", resource: "Room"), status: :unprocessable_content)
    end
  end

  def decline_private
    @room = Room.find(params[:room_id])
    authorize @room, :decline_private?, policy_class: Api::V1::RoomPolicy
    if !@room
      error(message: I18n.t("errors.resource_not_found", resource: "Room"), status: :not_found)
      return
    end
    is_current_user_participant = false
    @room.participants.each do | participant |
      if participant.user_id == current_user.id
        is_current_user_participant = true
        break
      end
    end
    if !is_current_user_participant
      error(message: I18n.t("errors.user_not_participant", resource: "Room"), status: :unauthorized)
      return
    end
    if @room.room_type.to_sym == :private_strangers_pending
      if @room.update(room_type: :private_strangers_declined)
        succeed(message: I18n.t("success.room_declined"))
      else
        error(message: I18n.t("errors.update_failure", resource: "Room"), status: :unprocessable_content)
      end
    else
      error(message: I18n.t("errors.only_pending_updatable", resource: "Room"), status: :unprocessable_content)
    end
  end
end
