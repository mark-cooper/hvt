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

ActiveRecord::Schema.define(version: 20170208000933) do

  create_table "interviewees", force: :cascade do |t|
    t.integer  "interview_id"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["interview_id"], name: "index_interviewees_on_interview_id"
  end

  create_table "interviewers", force: :cascade do |t|
    t.integer  "interview_id"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["interview_id"], name: "index_interviewers_on_interview_id"
  end

  create_table "interviews", force: :cascade do |t|
    t.integer  "record_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_interviews_on_record_id"
  end

  create_table "records", force: :cascade do |t|
    t.string   "identifier"
    t.string   "title"
    t.integer  "extent"
    t.string   "extent_expression"
    t.string   "collection"
    t.text     "abstract"
    t.text     "citation"
    t.text     "related_record_stmt"
    t.text     "identification_stmt"
    t.string   "summary_by"
    t.datetime "summary_date"
    t.string   "cataloged_by"
    t.datetime "cataloged_date"
    t.string   "input_by"
    t.datetime "input_date"
    t.string   "edited_by"
    t.datetime "edited_date"
    t.string   "corrected_by"
    t.datetime "corrected_date"
    t.string   "produced_by"
    t.datetime "produced_date"
    t.boolean  "has_mrc",             default: false
    t.boolean  "has_paradox",         default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
