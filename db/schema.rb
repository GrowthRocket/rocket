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

ActiveRecord::Schema.define(version: 20160817014910) do

  create_table "orders", force: :cascade do |t|
    t.integer  "total_price"
    t.integer  "plan_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "creator_name"
    t.string   "backer_name"
    t.integer  "price"
    t.integer  "quantity"
    t.string   "payment_method"
    t.string   "token"
    t.string   "aasm_state",     default: "order_placed"
    t.integer  "user_id"
    t.integer  "project_id"
    t.index ["aasm_state"], name: "index_orders_on_aasm_state"
  end

  create_table "plans", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "quantity",    default: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "price"
    t.integer  "project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "image"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "total_price", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_admin",               default: false
    t.string   "user_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
