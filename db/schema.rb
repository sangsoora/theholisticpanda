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

ActiveRecord::Schema.define(version: 2021_02_07_161407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "sender_id"], name: "index_conversations_on_recipient_id_and_sender_id", unique: true
  end

  create_table "faqs", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.string "category"
    t.string "audience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorite_practitioners", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "practitioner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practitioner_id"], name: "index_favorite_practitioners_on_practitioner_id"
    t.index ["user_id"], name: "index_favorite_practitioners_on_user_id"
  end

  create_table "favorite_services", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_favorite_services_on_service_id"
    t.index ["user_id"], name: "index_favorite_services_on_user_id"
  end

  create_table "health_goals", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "conversation_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "newsletters", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "practitioner_certifications", force: :cascade do |t|
    t.string "certification_type"
    t.string "name"
    t.bigint "practitioner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practitioner_id"], name: "index_practitioner_certifications_on_practitioner_id"
  end

  create_table "practitioner_languages", force: :cascade do |t|
    t.bigint "practitioner_id"
    t.bigint "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_practitioner_languages_on_language_id"
    t.index ["practitioner_id"], name: "index_practitioner_languages_on_practitioner_id"
  end

  create_table "practitioner_memberships", force: :cascade do |t|
    t.string "name"
    t.bigint "practitioner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practitioner_id"], name: "index_practitioner_memberships_on_practitioner_id"
  end

  create_table "practitioner_social_links", force: :cascade do |t|
    t.string "url"
    t.string "media_type"
    t.bigint "practitioner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practitioner_id"], name: "index_practitioner_social_links_on_practitioner_id"
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
    t.string "title"
    t.string "location"
    t.string "address"
    t.text "bio"
    t.text "approach"
    t.string "country_code"
    t.string "experience"
    t.string "video"
    t.string "timezone"
    t.boolean "insurance"
    t.string "checkout_session_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "payment_status"
    t.boolean "agreement_consent"
    t.string "agreement_status"
    t.string "status"
    t.float "latitude"
    t.float "longitude"
    t.string "background_check_status"
    t.boolean "background_check_consent"
    t.string "background_check_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_practitioners_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "comment"
    t.bigint "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_reviews_on_session_id"
  end

  create_table "service_health_goals", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "health_goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_goal_id"], name: "index_service_health_goals_on_health_goal_id"
    t.index ["service_id"], name: "index_service_health_goals_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "service_type"
    t.integer "duration"
    t.boolean "active"
    t.bigint "practitioner_specialty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.index ["practitioner_specialty_id"], name: "index_services_on_practitioner_specialty_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "start_time"
    t.integer "duration"
    t.string "session_type"
    t.datetime "primary_time"
    t.datetime "secondary_time"
    t.datetime "tertiary_time"
    t.text "message"
    t.integer "amount_cents", default: 0, null: false
    t.boolean "paid"
    t.string "link"
    t.string "status"
    t.text "cancel_reason"
    t.integer "cancelled_user_id"
    t.bigint "user_id"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "checkout_session_id"
    t.index ["service_id"], name: "index_sessions_on_service_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "specialties", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "risk"
    t.bigint "specialty_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specialty_category_id"], name: "index_specialties_on_specialty_category_id"
  end

  create_table "specialty_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_health_goals", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "health_goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_goal_id"], name: "index_user_health_goals_on_health_goal_id"
    t.index ["user_id"], name: "index_user_health_goals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "stripe_id"
    t.boolean "admin", default: false
    t.boolean "terms", default: false
    t.boolean "newsletter", default: false
    t.string "timezone"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "working_hours", force: :cascade do |t|
    t.integer "day"
    t.time "opens"
    t.time "closes"
    t.bigint "practitioner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practitioner_id"], name: "index_working_hours_on_practitioner_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "favorite_practitioners", "practitioners"
  add_foreign_key "favorite_practitioners", "users"
  add_foreign_key "favorite_services", "services"
  add_foreign_key "favorite_services", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "practitioner_certifications", "practitioners"
  add_foreign_key "practitioner_languages", "languages"
  add_foreign_key "practitioner_languages", "practitioners"
  add_foreign_key "practitioner_memberships", "practitioners"
  add_foreign_key "practitioner_social_links", "practitioners"
  add_foreign_key "practitioner_specialties", "practitioners"
  add_foreign_key "practitioner_specialties", "specialties"
  add_foreign_key "practitioners", "users"
  add_foreign_key "reviews", "sessions"
  add_foreign_key "service_health_goals", "health_goals"
  add_foreign_key "service_health_goals", "services"
  add_foreign_key "services", "practitioner_specialties"
  add_foreign_key "sessions", "services"
  add_foreign_key "sessions", "users"
  add_foreign_key "specialties", "specialty_categories"
  add_foreign_key "user_health_goals", "health_goals"
  add_foreign_key "user_health_goals", "users"
  add_foreign_key "working_hours", "practitioners"
end
