class Api::V1::UserRelationsController < ApplicationController
  include Api::V1::NotificationConcern

  def get_pending_requests
    relation_type = params[:relation_type]
    if ![ "friend", "follow" ].include?(relation_type)
      error(message: I18n.t("errors.invalid_relation_type"), status: :bad_request)
      return
    end
    @user_relations = UserRelation.where(receiver_id: current_user.id, relation_type: relation_type.to_sym, status: :pending).page(params[:page]).per(params[:per_page])
    authorize @user_relations, :get_pending_requests?, policy_class: Api::V1::UserRelationPolicy
    if @user_relations
      paginate(
        data:
        @user_relations.map do |user_relation|
        requester = User.find(user_relation.requester_id)
          {
          requester_id: user_relation.requester_id,
          receiver_id: user_relation.receiver_id,
          relation_type: user_relation.relation_type,
          status: user_relation.status,
          requester_avatar_url: requester.profile.avatar_url,
          requester_name: requester.profile.name,
          requester_surname: requester.profile.surname,
          requester_username: requester.username
        }
      end,
      meta: {
        total_count: @user_relations.count,
        current_page: @user_relations.current_page,
        total_pages: @user_relations.total_pages,
        per_page: params[:per_page].to_i || 20
      }
    )
    else
      error(message: I18n.t("errors.get_failure", resource: "User Relation"), status: :unprocessable_content)
    end
  end


  def get_accepted
    relation_type = params[:relation_type]
    if ![ "friend", "follow" ].include?(relation_type)
      error(message: I18n.t("errors.invalid_relation_type"), status: :bad_request)
      return
    end
    @user_relations = UserRelation.new
    if relation_type == "friend"
      @user_relations = UserRelation.where(
        "(requester_id = :user_id OR receiver_id = :user_id) AND relation_type = :type AND status = :status",
        user_id: current_user.id,
        type: UserRelation.relation_types[:friend],
        status: UserRelation.statuses[:accepted]
      ).page(params[:page]).per(params[:per_page])
    elsif relation_type == "follow"
      @user_relations = UserRelation.where(
        receiver_id: current_user.id,
        relation_type: :follow,
        status: :accepted
      ).page(params[:page]).per(params[:per_page])
    end
    authorize @user_relations, :get_accepted?, policy_class: Api::V1::UserRelationPolicy
    if @user_relations
      paginate(
        data:
        @user_relations.map do |user_relation|
          opponent_id = current_user.id == user_relation.requester_id ? user_relation.receiver_id : user_relation.requester_id
          opponent = Profile.find_by(user_id: opponent_id)
          {
                    capacity: "guest",
                    user_id: opponent.user_id,
                    username: opponent.user.username,
                    email: opponent.is_email_public ? opponent.user.email : nil,
                    name: opponent.name,
                    surname: opponent.surname,
                    bio: opponent.bio,
                    dob: opponent.dob,
                    gender:  opponent.is_gender_public ? opponent.gender : nil,
                    relationship_status: opponent.is_rel_status_public ? opponent.relationship_status : nil,
                    avatar_url: opponent.avatar_url,
                    bg_img_url: opponent.bg_img_url,
                    friends_amount: opponent.user.friends_amount,
                    followers_amount: opponent.user.followers_amount,
                    following_amount: opponent.user.following_amount,
                    is_email_public: opponent.is_email_public,
                    is_gender_public: opponent.is_gender_public,
                    is_rel_status_public: opponent.is_rel_status_public,
                    friend_status: relation_type == "friend" ? :accepted : UserRelation.friend_status(requester_id=current_user.id, receiver_id=opponent.user_id),
                    follow_status: relation_type == "follow" ? :accepted : UserRelation.follow_status(requester_id=current_user.id, receiver_id=opponent.user_id)
          }
        end,
        meta: {
          total_pages: @user_relations.total_pages,
          total_count: @user_relations.total_count,
          current_page: @user_relations.current_page,
          per_page: params[:per_page].to_i || 20
        }
      )
    else
      error(message: I18n.t("errors.get_failure", resource: "User Relation"), status: :unprocessable_content)
    end
  end

  def request_friend
    if params[:receiver_id] == current_user.id
      error(message: I18n.t("errors.cannot_socialize_with_yourself"), status: :bad_request)
      return
    end

    @user_relation = UserRelation.add_friend(current_user.id, params[:receiver_id], :pending)
    authorize @user_relation, :request_friend?, policy_class: Api::V1::UserRelationPolicy
    if @user_relation
      create_notification(user_id: params[:receiver_id], actor_id: current_user.id, notification_type: :friend_request)
      succeed(message: I18n.t("success.friend_requested"))
    else
      error(message: I18n.t("errors.create_failure", resource: "User Relation"), status: :unprocessable_content)
    end
  end

  def request_follow
    if params[:receiver_id] == current_user.id
      error(message: I18n.t("errors.cannot_socialize_with_yourself"), status: :bad_request)
      return
    end

    @user_relation = UserRelation.follow(current_user.id, params[:receiver_id], :pending)
    authorize @user_relation, :request_follow?, policy_class: Api::V1::UserRelationPolicy
    if @user_relation
      create_notification(user_id: params[:receiver_id], actor_id: current_user.id, notification_type: :follow_request)
      succeed(data: @user_relation)
    else
      error(message: I18n.t("errors.create_failure", resource: "User Relation"), status: :unprocessable_content)
    end
  end

  def accept_request
    relation_type = params[:relation_type]
    if ![ "friend", "follow" ].include?(relation_type)
      error(message: I18n.t("errors.invalid_relation_type"), status: :bad_request)
      return
    end
    @user_relation = UserRelation.find_by(requester_id: params[:requester_id], receiver_id: current_user.id, relation_type: relation_type.to_sym, status: :pending)
    authorize @user_relation, :accept_request?, policy_class: Api::V1::UserRelationPolicy
    if @user_relation
      @user_relation.update(status: :accepted)
      create_notification(user_id: params[:requester_id], actor_id: current_user.id, notification_type: "#{relation_type}_request_accepted".to_sym)
      succeed(message: I18n.t("success.#{relation_type}_request_accepted"))
    else
      error(message: I18n.t("errors.update_failure", resource: "User Relation"), status: :unprocessable_content)
    end
  end

  def decline_request
    relation_type = params[:relation_type]
    if ![ "friend", "follow" ].include?(relation_type)
      error(message: I18n.t("errors.invalid_relation_type"), status: :bad_request)
      return
    end

    @user_relation = UserRelation.find_by(requester_id: params[:requester_id], receiver_id: current_user.id, relation_type: relation_type.to_sym, status: :pending)
    authorize @user_relation, :decline_request?, policy_class: Api::V1::UserRelationPolicy
    if @user_relation
      @user_relation.destroy
      succeed(message: I18n.t("success.#{relation_type}_request_declined"))
    else
      error(message: I18n.t("errors.update_failure", resource: "User Relation"), status: :unprocessable_content)
    end
  end
end
