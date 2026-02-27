class Request < ApplicationRecord
  belongs_to :sender,   class_name: "User"
  belongs_to :receiver, class_name: "User"

  enum :request_type, { private_message_strangers: 0, group_join: 1, friend: 2, follow: 3 }
  enum :status, { pending: 0, accepted: 1, declined: 2 }
end
