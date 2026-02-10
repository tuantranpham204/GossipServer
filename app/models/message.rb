class Message < ApplicationRecord
  belongs_to :room
  belongs_to :sender, class_name: "User"

  # ordinary messages are messages between general users
  enum :message_type, { ordinary: 1, system: 2 }
end
