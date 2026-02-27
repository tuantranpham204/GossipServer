class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum :role, { declined_strangers: -1, pending_strangers: 0, private_strangers: 1, private_friends: 2, group_host: 3, group_member: 4 }
end
