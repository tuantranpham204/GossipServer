class Profile < ApplicationRecord
  VALID_NAME_REGEX = /\A[\p{L}\p{M}\d\s]+\z/
  belongs_to :user

  has_one_attached :avatar
  has_one_attached :bg_img

  enum :gender, { male: 1, female: 0 }
  enum :relationship_status, { single: 0, in_a_relationship: 1, married: 2 }

  validates :name, presence: true, length: { minimum: 1, maximum: 50 }, format: { with: VALID_NAME_REGEX }
  validates :surname, presence: true, length: { minimum: 1, maximum: 50 }, format: { with: VALID_NAME_REGEX }

  searchkick word_start: [ :name, :surname, :username, :full_name, :reversed_full_name ]

  def search_data
    {
      username: user.username,
      name: name,
      surname: surname,
      full_name: "#{name} #{surname}".strip,
      reversed_full_name: "#{surname} #{name}".strip
    }
  end

  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.url_for(avatar)
    else
      ENV["DEFAULT_AVT_URL"] || nil
    end
  end

  def bg_img_url
    if bg_img.attached?
      Rails.application.routes.url_helpers.url_for(bg_img)
    else
      ENV["DEFAULT_BG_IMG_URL"] || nil
    end
  end

  def as_json(options = {})
    super(options).merge(
      "avatar_url" => avatar_url,
      "bg_img_url" => bg_img_url
    )
  end
end
