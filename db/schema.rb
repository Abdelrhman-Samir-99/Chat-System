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

ActiveRecord::Schema.define(version: 2022_01_24_185914) do

  create_table "applications", force: :cascade do |t|
    t.string "Application_Token"
    t.string "name"
    t.integer "chats_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_chats_count", default: 0, null: false
    t.index ["Application_Token"], name: "index_applications_on_Application_Token", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.integer "Application_id", null: false
    t.integer "Chat_id"
    t.integer "messages_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_messages_count", default: 0, null: false
    t.index ["Application_id"], name: "index_chats_on_Application_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "Application_id", null: false
    t.integer "Chat_id", null: false
    t.text "body"
    t.integer "message_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["Application_id"], name: "index_messages_on_Application_id"
    t.index ["Chat_id"], name: "index_messages_on_Chat_id"
  end

  add_foreign_key "chats", "Applications"
  add_foreign_key "messages", "Applications"
  add_foreign_key "messages", "Chats"
end
