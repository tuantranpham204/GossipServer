class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum :role, { private_strangers: 1, private_friends: 2, group_host: 3, group_member: 4 }
end
