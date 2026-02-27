class UserRelation < ApplicationRecord
  belongs_to :requester,  class_name: "User"
  belongs_to :receiver,   class_name: "User"

  enum :relation_type, { friend: 1, follow: 2 }

  def self.get_friends_amount(user_id)
    if user_id.nil?
      return 0
    end
    amt = UserRelation.where(
      "(requester_id = :user_id OR receiver_id = :user_id) AND relation_type = :type",
      user_id: user_id,
      type: relation_types[:friend]
    ).count
    User.find(user_id).update_column(:friends_amount, amt)
    amt
  end

  def self.get_followers_amount(user_id)
    if user_id.nil?
      return 0
    end
    amt = UserRelation.where(
      "(requester_id = :user_id OR receiver_id = :user_id) AND relation_type = :type",
      user_id: user_id,
      type: relation_types[:friend]
    ).count
    User.find(user_id).update_column(:friends_amount, amt)
    amt
  end

  def self.get_following_amount(user_id)
    if user_id.nil?
      return 0
    end
    user_id = user_id.to_i
    amt = UserRelation.where(requester_id: user_id, relation_type: :follow).count
    User.find(user_id).update_column(:following_amount, amt)
    amt
  end

  def self.add_friend(requester_id, receiver_id)
    self.requester_id = requester_id
    self.receiver_id = receiver_id
    self.relation_type = :friend

    if self.save
      requester = User.find(requester_id)
      receiver = User.find(receiver_id)

      requester.update_column(:friends_amount, requester.friends_amount + 1)
      receiver.update_column(:friends_amount, receiver.friends_amount + 1)
    end
  end

  def self.remove_friend(requester_id, receiver_id)
    relation = find_by(requester_id: requester_id.to_i, receiver_id: receiver_id.to_i, relation_type: :friend)
    relation = find_by(requester_id: receiver_id.to_i, receiver_id: requester_id.to_i, relation_type: :friend) if relation.nil?
    requester = User.find(requester_id)
    receiver = User.find(receiver_id)

    if relation.nil? || requester.friends_amount <= 0 || receiver.friends_amount <= 0
      return false
    end

    if relation.destroy!
      requester.update_column(:friends_amount, requester.friends_amount - 1)
      receiver.update_column(:friends_amount, receiver.friends_amount - 1)
    end
  end


  def follow(requester_id, receiver_id)
    self.requester_id = requester_id
    self.receiver_id = receiver_id
    self.relation_type = :follow

    if self.save
      requester = User.find(requester_id)
      receiver = User.find(receiver_id)

      requester.update_column(:following_amount, requester.following_amount + 1)
      receiver.update_column(:followers_amount, receiver.followers_amount + 1)
    end
  end

  def unfollow(requester_id, receiver_id)
    relation = find_by(requester_id: requester_id.to_i, receiver_id: receiver_id.to_i, relation_type: :follow)
    requester = User.find(requester_id.to_i)
    receiver = User.find(receiver_id.to_i)

    if relation.nil? || requester.following_amount <= 0 || receiver.followers_amount <= 0
      return false
    end

    if relation.destroy!
      requester.update_column(:following_amount, requester.following_amount - 1)
      receiver.update_column(:followers_amount, receiver.followers_amount - 1)
    end
  end
end
