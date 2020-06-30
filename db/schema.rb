# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_30_094857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conditions", force: :cascade do |t|
    t.string "name"
    t.bigint "specialty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specialty_id"], name: "index_conditions_on_specialty_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "practitioner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practitioner_id"], name: "index_favorites_on_practitioner_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "practitioner_languages", force: :cascade do |t|
    t.bigint "practitioner_id"
    t.bigint "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_practitioner_languages_on_language_id"
    t.index ["practitioner_id"], name: "index_practitioner_languages_on_practitioner_id"
  end

  create_table "practitioner_specialties", force: :cascade do |t|
    t.bigint "practitioner_id"
    t.bigint "specialty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practitioner_id"], name: "index_practitioner_specialties_on_practitioner_id"
    t.index ["specialty_id"], name: "index_practitioner_specialties_on_specialty_id"
  end

  create_table "practitioners", force: :cascade do |t|
    t.string "location"
    t.string "address"
    t.text "bio"
    t.string "video"
    t.float "latitude"
    t.float "longitude"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_practitioners_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.integer "duration"
    t.bigint "practitioner_specialty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practitioner_specialty_id"], name: "index_services_on_practitioner_specialty_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "total_price"
    t.boolean "paid"
    t.string "status"
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_sessions_on_service_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "specialties", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_conditions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "condition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_id"], name: "index_user_conditions_on_condition_id"
    t.index ["user_id"], name: "index_user_conditions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "conditions", "specialties"
  add_foreign_key "favorites", "practitioners"
  add_foreign_key "favorites", "users"
  add_foreign_key "practitioner_languages", "languages"
  add_foreign_key "practitioner_languages", "practitioners"
  add_foreign_key "practitioner_specialties", "practitioners"
  add_foreign_key "practitioner_specialties", "specialties"
  add_foreign_key "practitioners", "users"
  add_foreign_key "services", "practitioner_specialties"
  add_foreign_key "sessions", "services"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_conditions", "conditions"
  add_foreign_key "user_conditions", "users"
end
