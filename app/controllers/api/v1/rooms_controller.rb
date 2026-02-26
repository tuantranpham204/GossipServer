class Api::V1::RoomsController < ApplicationController
  include Api::V1::NotificationConcern

  def show_private
    status = params[:status]
    if ![ "accepted", "pending", "declined" ].include?(status)
      error(message: I18n.t("errors.invalid_resource_type", resource: "Room"), status: :unprocessable_content)
      return
    end
    room_type = status == "accepted" ? :private_strangers : "private_strangers_#{status}".to_sym
    @rooms = Room.joins("JOIN participants p ON p.room_id = rooms.id")
            .where(room_type: room_type)
            .where(" p.user_id = ? ", current_user.id)
            .page(params[:page])
            .per(params[:per_page])
    authorize @rooms, :show_private?, policy_class: Api::V1::RoomPolicy
    if @rooms
      paginate(
        data: @rooms.map do | room |
          opponent = Participant.joins("JOIN rooms r ON r.id = participants.room_id").where(room_id: room.id).where("user_id != ?", current_user.id).first
          { **room.as_json,
            opponent: {
              user_id: opponent.user_id,
              role: opponent.role,
              avatar: opponent.user.profile.avatar_url,
              name: opponent.user.profile.name,
              surname: opponent.user.profile.surname,
              username: opponent.user.username
            }
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
