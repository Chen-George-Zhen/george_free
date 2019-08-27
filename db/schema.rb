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

ActiveRecord::Schema.define(version: 2019_08_27_144523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lottery_tickets", force: :cascade do |t|
    t.string "type", null: false
    t.string "issue_numer", null: false
    t.string "red_balls", default: [], array: true
    t.string "blue_balls", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type", "issue_numer"], name: "index_lottery_tickets_on_type_and_issue_numer", unique: true
  end

end
