# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140101180140) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "current_balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry"

  create_table "transactions", force: true do |t|
    t.date     "date"
    t.integer  "amount_in_pennies"
    t.string   "subcategory"
    t.string   "description"
    t.integer  "account_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
