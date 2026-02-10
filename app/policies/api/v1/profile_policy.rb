class Api::V1::ProfilePolicy < ApplicationPolicy
  def search?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def show?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def update?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def update_images?
    user && user.roles.include?(User::ROLES[:USER])
  end

  def get_images?
    user && user.roles.include?(User::ROLES[:USER])
  end
end
