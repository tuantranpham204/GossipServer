class UserRelation < ApplicationRecord
  belongs_to :requester,  class_name: "User"
  belongs_to :receiver,   class_name: "User"

  enum :relation_type, { friend: 1, follow: 2 }
  enum :status, { pending: 0, accepted: 1, declined: -1 }

  def self.get_friends_amount(user_id)
    amt = UserRelation.where(requester_id: user_id.to_i, relation_type: :friend).count
    User.find(user_id).update_column(:friends_amount, amt)
    amt
  end

  def self.get_followers_amount(user_id)
    amt = UserRelation.where(receiver_id: user_id.to_i, relation_type: :follow).count
    User.find(user_id).update_column(:followers_amount, amt)
    amt
  end

  def self.get_following_amount(user_id)
    amt = UserRelation.where(requester_id: user_id.to_i, relation_type: :follow).count
    User.find(user_id).update_column(:following_amount, amt)
    amt
  end

  def self.add_friend(requester_id, receiver_id, status)
    if self.create!(requester_id: requester_id.to_i, receiver_id: receiver_id.to_i, relation_type: :friend, status: status)
      requester = User.find(requester_id)
      receiver = User.find(receiver_id)

      requester.update_column(:friends_amount, requester.friends_amount + 1)
      receiver.update_column(:friends_amount, receiver.friends_amount + 1)
    end
  end

  def self.remove_friend(requester_id, receiver_id)
    self.requester_id = requester_id.to_i
    self.receiver_id = receiver_id.to_i
    self.relation_type = :friend

    requester = User.find(requester_id)
    receiver = User.find(receiver_id)

    if requester.friends_amount <= 0 || receiver.friends_amount <= 0
      return false
    end

    if self.destroy
      requester.update_column(:friends_amount, requester.friends_amount - 1)
      receiver.update_column(:friends_amount, receiver.friends_amount - 1)
    end
  end


  def self.follow(requester_id, receiver_id, status)
    if self.create!(requester_id: requester_id.to_i, receiver_id: receiver_id.to_i, relation_type: :follow, status: status)
      requester = User.find(requester_id)
      receiver = User.find(receiver_id)

      requester.update_column(:following_amount, requester.following_amount + 1)
      receiver.update_column(:followers_amount, receiver.followers_amount + 1)
    end
  end

  def self.unfollow(requester_id, receiver_id)
    requester = User.find(requester_id.to_i)
    receiver = User.find(receiver_id.to_i)

    if requester.following_amount <= 0 || receiver.followers_amount <= 0
      return false
    end

    if self.destroy
      requester.update_column(:following_amount, requester.following_amount - 1)
      receiver.update_column(:followers_amount, receiver.followers_amount - 1)
    end
  end
end
