# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_10_024239) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "exp", null: false
    t.string "jti", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.jsonb "attachment_data"
    t.text "content"
    t.datetime "created_at", null: false
    t.boolean "is_deleted"
    t.integer "message_type"
    t.bigint "room_id", null: false
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "actor_id", null: false
    t.jsonb "content", default: {}
    t.datetime "created_at", null: false
    t.integer "notification_type", null: false
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "participants", primary_key: ["user_id", "room_id"], force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "role", null: false
    t.bigint "room_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["room_id"], name: "index_participants_on_room_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "profiles", primary_key: "user_id", force: :cascade do |t|
    t.boolean "allow_direct_follows", default: true, null: false
    t.jsonb "avatar_data", default: {"url" => "https://i.pinimg.com/736x/cc/58/7b/cc587bf43e916ec9197c8842d675265c.jpg", "public_id" => nil}
    t.string "bio", default: ""
    t.datetime "created_at", null: false
    t.date "dob"
    t.integer "gender", null: false
    t.boolean "is_email_public", default: false, null: false
    t.boolean "is_gender_public", default: true, null: false
    t.boolean "is_rel_status_public", default: false, null: false
    t.string "name", null: false
    t.integer "relationship_status", default: 0, null: false
    t.integer "status", default: 1, null: false
    t.string "surname", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "receiver_id", null: false
    t.integer "request_type"
    t.bigint "sender_id", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_requests_on_receiver_id"
    t.index ["sender_id"], name: "index_requests_on_sender_id"
    t.unique_constraint ["sender_id", "receiver_id", "request_type"], name: "unique_constraints"
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.string "name"
    t.integer "room_type", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_relations", primary_key: ["requester_id", "receiver_id"], force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "receiver_id", null: false
    t.integer "relation_type", null: false
    t.bigint "requester_id", null: false
    t.integer "status", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_user_relations_on_receiver_id"
    t.index ["requester_id"], name: "index_user_relations_on_requester_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "followers_amount", default: 0
    t.integer "following_amount", default: 0
    t.integer "friends_amount", default: 0
    t.string "locale", default: "en"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "roles", default: [1], null: false, array: true
    t.string "timestamps"
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "participants", "rooms"
  add_foreign_key "participants", "users"
  add_foreign_key "profiles", "users", on_delete: :cascade
  add_foreign_key "requests", "users", column: "receiver_id"
  add_foreign_key "requests", "users", column: "sender_id"
  add_foreign_key "user_relations", "users", column: "receiver_id"
  add_foreign_key "user_relations", "users", column: "requester_id"
end
