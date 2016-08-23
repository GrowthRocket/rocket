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

ActiveRecord::Schema.define(version: 20160823115137) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "balance",      default: 0
    t.integer  "amount",       default: 0
    t.integer  "user_id"
    t.integer  "profit",       default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "account_name"
  end

  create_table "bill_payments", force: :cascade do |t|
    t.string   "order_id"
    t.string   "channel_id"
    t.integer  "amount"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "plan_id"
    t.string   "bill_status"
    t.string   "payment_method"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "project_name"
    t.string   "backer_name"
    t.index ["bill_status"], name: "index_bill_payments_on_bill_status"
  end

  create_table "bill_payouts", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "amount"
    t.string   "account_name"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "bill_status"
    t.string   "project_name"
    t.string   "creator_name"
    t.index ["bill_status"], name: "index_bill_payouts_on_bill_status"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identity_verifications", force: :cascade do |t|
    t.integer  "verify_type"
    t.integer  "user_id"
    t.string   "title"
    t.string   "image"
    t.integer  "verify_status"
    t.string   "message"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "project_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "actor_id"
    t.datetime "read_at"
    t.string   "action"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

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
    t.integer  "quantity",        default: 1
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "price"
    t.integer  "project_id"
    t.integer  "plan_goal"
    t.integer  "plan_progress",   default: 0
    t.integer  "backer_quantity", default: 0
  end

  create_table "posts", force: :cascade do |t|
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "image"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "fund_goal"
    t.boolean  "is_hidden",       default: true
    t.integer  "fund_progress",   default: 0
    t.integer  "backer_quantity", default: 0
    t.integer  "plans_count",     default: 0
    t.integer  "category_id"
    t.string   "aasm_state",      default: "project_created"
    t.index ["aasm_state"], name: "index_projects_on_aasm_state"
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
    t.string   "image"
    t.integer  "phone_number"
    t.integer  "captcha"
    t.string   "aasm_state"
    t.index ["aasm_state"], name: "index_users_on_aasm_state"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
