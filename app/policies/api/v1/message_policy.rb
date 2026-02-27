class Api::V1::MessagePolicy < ApplicationPolicy
  def create?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def show_by_room?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def read?
    user && user.roles.include?(User::ROLES[:USER])
  end
end
