class Notification < ApplicationRecord
  belongs_to :recipient,  class_name: "User"
  belongs_to :actor,      class_name: "User"

  enum :notifiable_type, { unread_message: 1, private_message_strangers_request: 2, group_join_request: 3, friend_request: 4, follow_request: 5 }
  enum :status, { unread: 0, read: 1 }
end
