class Profile < ApplicationRecord
  VALID_NAME_REGEX = /\A[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžæœÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ ,.'-]+\z/
  belongs_to :user

  validates :name, presence: true, length: { minimum: 1, maximum: 50 }, format: { with: VALID_NAME_REGEX }
  validates :surname, presence: true, length: { minimum: 1, maximum: 50 }, format: { with: VALID_NAME_REGEX }
end
