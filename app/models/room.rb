class Room < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :messages, dependent: :destroy

  enum :room_type, { private_strangers_declined: -1, private_strangers_pending: 0, private_strangers: 1, private_friends: 2, group_room: 3 }

  def self.private_room_type(user1_id, user2_id)
    private_room_types = [
      :private_strangers_declined,
      :private_strangers_pending,
      :private_strangers,
      :private_friends
    ]

    room = Room.joins("INNER JOIN participants p1 ON p1.room_id = rooms.id")
               .joins("INNER JOIN participants p2 ON p2.room_id = rooms.id")
               .where(room_type: private_room_types)
               .where("p1.user_id = ? AND p2.user_id = ?", user1_id, user2_id)
               .first

    room&.room_type
  end
end
