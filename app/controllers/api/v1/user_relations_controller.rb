class Api::V1::UserRelationsController < ApplicationController
  include Api::V1::NotificationConcern

  def get_pending_requests
    relation_type = params[:relation_type]
    if ![ "friend", "follow" ].include?(relation_type)
      error(message: I18n.t("errors.invalid_relation_type"), status: :bad_request)
      return
    end
    @user_relations = UserRelation.where(receiver_id: current_user.id, relation_type: relation_type.to_sym, status: :pending)
    authorize @user_relations, :get_pending_requests?, policy_class: Api::V1::UserRelationPolicy
    if @user_relations
      succeed(
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
      end)
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

    is_receiver_allowed_direct_follow = User.find(params[:receiver_id]).profile.allow_direct_follows
    if !is_receiver_allowed_direct_follow
      status = :pending
    else
      status = :accepted
    end
    @user_relation = UserRelation.follow(current_user.id, params[:receiver_id], status)
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
