class Room < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :messages, dependent: :destroy

  enum :room_type, { private_strangers_declined: -1, private_strangers_pending: 0, private_strangers: 1, private_friends: 2, group_room: 3 }
end
