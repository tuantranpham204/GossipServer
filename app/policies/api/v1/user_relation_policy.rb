class Api::V1::UserRelationPolicy < ApplicationPolicy
  def get_pending_requests?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def request_friend?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def accept_request?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def decline_request?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def request_follow?
    user && user.roles.include?(User::ROLES[:USER])
  end
end
