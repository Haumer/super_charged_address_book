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

ActiveRecord::Schema[7.0].define(version: 2023_05_22_094727) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_reminders", force: :cascade do |t|
    t.bigint "reminder_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_reminders_on_contact_id"
    t.index ["reminder_id"], name: "index_contact_reminders_on_reminder_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "birthday"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_action_contacts", force: :cascade do |t|
    t.bigint "daily_action_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_daily_action_contacts_on_contact_id"
    t.index ["daily_action_id"], name: "index_daily_action_contacts_on_daily_action_id"
  end

  create_table "daily_actions", force: :cascade do |t|
    t.boolean "completed", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_daily_actions_on_user_id"
  end

  create_table "group_contacts", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_group_contacts_on_contact_id"
    t.index ["group_id"], name: "index_group_contacts_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "interval"
    t.string "name"
    t.bigint "user_id", null: false
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_notes_on_contact_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "target_date"
    t.date "actual_date"
    t.integer "interval", default: 30
    t.boolean "reoccurring", default: true
    t.boolean "active", default: true
    t.boolean "contacted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "birthday_reminder", default: false
    t.index ["user_id"], name: "index_reminders_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "columns"
    t.integer "daily_action_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "user_contacts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "contact_id", null: false
    t.boolean "shared"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_user_contacts_on_contact_id"
    t.index ["user_id"], name: "index_user_contacts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contact_reminders", "contacts"
  add_foreign_key "contact_reminders", "reminders"
  add_foreign_key "daily_action_contacts", "contacts"
  add_foreign_key "daily_action_contacts", "daily_actions"
  add_foreign_key "daily_actions", "users"
  add_foreign_key "group_contacts", "contacts"
  add_foreign_key "group_contacts", "groups"
  add_foreign_key "groups", "users"
  add_foreign_key "notes", "contacts"
  add_foreign_key "notes", "users"
  add_foreign_key "reminders", "users"
  add_foreign_key "settings", "users"
  add_foreign_key "user_contacts", "contacts"
  add_foreign_key "user_contacts", "users"
end
