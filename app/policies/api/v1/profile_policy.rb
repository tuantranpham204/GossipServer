class Api::V1::ProfilePolicy < ApplicationPolicy
  def search?
    user && user.roles.include?(User::ROLES[:USER])
  end
end
