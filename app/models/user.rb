class User < ApplicationRecord
  # Validation RegEx
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USERNAME_REGEX = /\A(?![._-])(?!.*[._-]{2})[a-zA-Z0-9._-]+(?<![._-])\z/
  VALID_PASSWORD_REGEX = /\A(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\S+$).{8,20}\z/

  # Roles
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

  # Validations
  validates :username, presence: true, length: { minimum: 5, maximum: 30 }, uniqueness: { case_sensitive: false }, format: { with: VALID_USERNAME_REGEX }
  validates :password, presence: true, length: { minimum: 6, maximum: 20 }, format: { with: VALID_PASSWORD_REGEX }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP || VALID_EMAIL_REGEX },
            length: { maximum: 105 }
end
