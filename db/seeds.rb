# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

admin = User.create!(
  username: "urfavadmin",
  email: "admin@example.com",
  password: ENV["DEFAULT_SEED_USERS_PASSWORD"],
  created_at: Time.now,
  updated_at: Time.now,
  confirmed_at: Time.now,
  profile_attributes: {
    name: "Min",
    surname: "Ad",
    gender: 1,
    relationship_status: 1,
    bio: "I am just an admin"
  }
)
admin.roles << User::ROLES[:ADMIN]
admin.save!

10.times do |i|
  User.create!(
    username: "urfavuser#{i+1}",
    email: "favuser#{i+1}@example.com",
    password: ENV["DEFAULT_SEED_USERS_PASSWORD"],
    created_at: Time.now,
    updated_at: Time.now,
    confirmed_at: Time.now,
    profile_attributes: {
      name: "User",
      surname: "Favourite",
      gender: 0,
      relationship_status: 0,
      bio: "I am just ur favourable user #{i+1}"
    }
  )
end

10.times do |i|
  User.create!(
    username: "urhateduser#{i+1}",
    email: "hateduser#{i+1}@example.com",
    password: ENV["DEFAULT_SEED_USERS_PASSWORD"],
    created_at: Time.now,
    updated_at: Time.now,
    confirmed_at: Time.now,
    profile_attributes: {
      name: "User",
      surname: "Hated",
      gender: 0,
      relationship_status: 0,
      bio: "I am just ur hated user #{i+1}"
    }
  )
end
