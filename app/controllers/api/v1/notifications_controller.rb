class Api::V1::NotificationsController < ApplicationController
  include Pundit::Authorization

  def show_by_user
    if !current_user.id
      error(message: I18n.t("devise.failure.unauthenticated"), status: :unauthorized)
    end

    @notifications = Notification.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(params[:per_page])
    authorize @notifications, :show?, policy_class: Api::V1::NotificationPolicy
    paginate(
      data:
      @notifications.map do |notification|
        @profile = Profile.find_by(user_id: notification.actor_id)
        {
          **notification.to_h,
          actor_avatar_url: @profile.avatar_url,
          actor_username: @profile.user.username
        }
      end,
      meta: {
        total_pages: @notifications.total_pages,
        total_count: @notifications.total_count,
        current_page: @notifications.current_page,
        per_page: params[:per_page]
      }
    )
  end

  def read
    @notification = Notification.find_by(id: params[:id])
    authorize @notification, :read?, policy_class: Api::V1::NotificationPolicy
    if !@notification
      error(message: I18n.t("errors.resource_not_found", resource: "Notification"), status: :not_found)
    elsif @notification.update(status: :read)
      succeed(data: @notification)
    else
      error(message: I18n.t("errors.update_failure", resource: "Notification"), status: :unprocessable_content)
    end
  end

  def read_all
    if !current_user.id
      error(message: I18n.t("devise.failure.unauthenticated"), status: :unauthorized)
    end

    @notification = Notification.where(user_id: current_user.id)
    authorize @notification, :read_all?, policy_class: Api::V1::NotificationPolicy
    if !@notification
      error(message: I18n.t("errors.resource_not_found", resource: "Notification"), status: :not_found)
    elsif @notification.where(status: :unread).update_all(status: :read)
      succeed(message: I18n.t("success.all_notifications_read"))
    else
      error(message: I18n.t("errors.update_failure", resource: "Notification status"), status: :unprocessable_content)
    end
  end
end
