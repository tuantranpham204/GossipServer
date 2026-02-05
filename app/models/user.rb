class User < ApplicationRecord
  ROLES = {
    USER: 1,
    ADMIN: 2
  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one :profile, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :profile
end
