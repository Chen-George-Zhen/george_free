# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_06_134335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coins", force: :cascade do |t|
    t.string "currency"
    t.decimal "entent", precision: 40, scale: 20
    t.decimal "basic_price", precision: 40, scale: 20
    t.decimal "investment_amount", precision: 40, scale: 20
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["currency"], name: "index_coins_on_currency", unique: true
  end

  create_table "lottery_tickets", force: :cascade do |t|
    t.string "type", null: false
    t.string "issue_numer", null: false
    t.string "red_balls", default: [], array: true
    t.string "blue_balls", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type", "issue_numer"], name: "index_lottery_tickets_on_type_and_issue_numer", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "coin_id"
    t.string "symbol"
    t.decimal "price", precision: 40, scale: 20
    t.decimal "amount", precision: 40, scale: 20
    t.string "tr_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coin_id"], name: "index_transactions_on_coin_id"
  end

end
