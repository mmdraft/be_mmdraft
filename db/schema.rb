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

ActiveRecord::Schema[7.1].define(version: 2024_03_02_185552) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "draft_picks", force: :cascade do |t|
    t.bigint "user_league_id", null: false
    t.integer "round_number"
    t.bigint "team_id", null: false
    t.integer "draft_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_draft_picks_on_team_id"
    t.index ["user_league_id"], name: "index_draft_picks_on_user_league_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.integer "manager_id"
    t.integer "draft_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "draft_date_time", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "seed"
    t.string "region"
    t.string "conference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_leagues", force: :cascade do |t|
    t.bigint "league_id", null: false
    t.bigint "user_id", null: false
    t.boolean "manager"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_user_leagues_on_league_id"
    t.index ["user_id"], name: "index_user_leagues_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "auth_token"
    t.string "google_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "draft_picks", "teams"
  add_foreign_key "draft_picks", "user_leagues"
  add_foreign_key "user_leagues", "leagues"
  add_foreign_key "user_leagues", "users"
end
