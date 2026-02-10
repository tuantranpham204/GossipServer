class Message < ApplicationRecord
  belongs_to :room
  belongs_to :sender, class_name: "User"

  # ordinary messages are messages between general users
  enum :message_type, { ordinary_text: 1, ordinary_media: 2, system_text: 3 }
end
