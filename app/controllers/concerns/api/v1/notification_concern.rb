module Api::V1::NotificationConcern
      extend ActiveSupport::Concern

      def create_notification(user_id: nil, actor_id: nil, notification_type: nil, content: nil)
        @notification = Notification.new(user_id: user_id, actor_id: actor_id, notification_type: notification_type)
        authorize @notification, :create?, policy_class: Api::V1::NotificationPolicy
        if @notification.save!
          @notification
        else
          nil
        end
      end
end
