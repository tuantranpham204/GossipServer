class Api::V1::NotificationPolicy < ApplicationPolicy
  def show?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def read?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def read_all?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def create?
    user && user.roles.include?(User::ROLES[:USER])
  end
end
