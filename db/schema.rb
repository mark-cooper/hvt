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

ActiveRecord::Schema.define(version: 20170209234244) do

  create_table "activities", force: :cascade do |t|
    t.integer  "record_id"
    t.integer  "interview_id"
    t.integer  "proof_id"
    t.integer  "agent_id"
    t.integer  "cataloger_id"
    t.integer  "corrector_id"
    t.integer  "editor_id"
    t.integer  "inputter_id"
    t.integer  "producer_id"
    t.integer  "proofer_id"
    t.integer  "summarizer_id"
    t.integer  "interviewee_id"
    t.integer  "interviewer_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["agent_id"], name: "index_activities_on_agent_id"
    t.index ["cataloger_id"], name: "index_activities_on_cataloger_id"
    t.index ["corrector_id"], name: "index_activities_on_corrector_id"
    t.index ["editor_id"], name: "index_activities_on_editor_id"
    t.index ["inputter_id"], name: "index_activities_on_inputter_id"
    t.index ["interview_id"], name: "index_activities_on_interview_id"
    t.index ["interviewee_id"], name: "index_activities_on_interviewee_id"
    t.index ["interviewer_id"], name: "index_activities_on_interviewer_id"
    t.index ["producer_id"], name: "index_activities_on_producer_id"
    t.index ["proof_id"], name: "index_activities_on_proof_id"
    t.index ["proofer_id"], name: "index_activities_on_proofer_id"
    t.index ["record_id"], name: "index_activities_on_record_id"
    t.index ["summarizer_id"], name: "index_activities_on_summarizer_id"
  end

  create_table "agents", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type", "name"], name: "index_agents_on_type_and_name", unique: true
  end

  create_table "authorities", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type", "name"], name: "index_authorities_on_type_and_name", unique: true
  end

  create_table "collections", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interviews", force: :cascade do |t|
    t.integer  "record_id"
    t.datetime "date"
    t.string   "date_expression"
    t.string   "length"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["record_id"], name: "index_interviews_on_record_id"
  end

  create_table "proofs", force: :cascade do |t|
    t.integer  "record_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_proofs_on_record_id"
  end

  create_table "records", force: :cascade do |t|
    t.string   "identifier"
    t.string   "title"
    t.integer  "extent"
    t.string   "extent_expression"
    t.integer  "collection_id"
    t.text     "abstract"
    t.text     "note"
    t.text     "citation"
    t.text     "related_record_stmt"
    t.text     "identification_stmt"
    t.datetime "summary_date"
    t.datetime "cataloged_date"
    t.datetime "input_date"
    t.datetime "edited_date"
    t.datetime "corrected_date"
    t.datetime "produced_date"
    t.boolean  "has_mrc",             default: false
    t.boolean  "has_paradox",         default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["collection_id"], name: "index_records_on_collection_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", force: :cascade do |t|
    t.integer  "record_id"
    t.integer  "authority_id"
    t.integer  "subject_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["authority_id"], name: "index_terms_on_authority_id"
    t.index ["record_id"], name: "index_terms_on_record_id"
    t.index ["subject_id"], name: "index_terms_on_subject_id"
  end

end
