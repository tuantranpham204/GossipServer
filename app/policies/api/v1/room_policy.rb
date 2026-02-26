class Api::V1::RoomPolicy < ApplicationPolicy
  def show_private?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def request_private?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def accept_private?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def decline_private?
    user && user.roles.include?(User::ROLES[:USER])
  end
end
