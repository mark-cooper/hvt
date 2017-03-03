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

ActiveRecord::Schema.define(version: 20170301154547) do

  create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.index ["agent_id"], name: "index_activities_on_agent_id", using: :btree
    t.index ["cataloger_id"], name: "index_activities_on_cataloger_id", using: :btree
    t.index ["corrector_id"], name: "index_activities_on_corrector_id", using: :btree
    t.index ["editor_id"], name: "index_activities_on_editor_id", using: :btree
    t.index ["inputter_id"], name: "index_activities_on_inputter_id", using: :btree
    t.index ["interview_id"], name: "index_activities_on_interview_id", using: :btree
    t.index ["interviewee_id"], name: "index_activities_on_interviewee_id", using: :btree
    t.index ["interviewer_id"], name: "index_activities_on_interviewer_id", using: :btree
    t.index ["producer_id"], name: "index_activities_on_producer_id", using: :btree
    t.index ["proof_id"], name: "index_activities_on_proof_id", using: :btree
    t.index ["proofer_id"], name: "index_activities_on_proofer_id", using: :btree
    t.index ["record_id"], name: "index_activities_on_record_id", using: :btree
    t.index ["summarizer_id"], name: "index_activities_on_summarizer_id", using: :btree
  end

  create_table "agents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type", "name"], name: "index_agents_on_type_and_name", unique: true, using: :btree
  end

  create_table "authorities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type"
    t.string   "name"
    t.string   "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type", "name", "source"], name: "index_authorities_on_type_and_name_and_source", unique: true, using: :btree
  end

  create_table "collections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "record_id"
    t.datetime "date"
    t.string   "date_expression"
    t.string   "length"
    t.text     "note",            limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["record_id"], name: "index_interviews_on_record_id", using: :btree
  end

  create_table "inventory_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tape_id"
    t.string   "permanent_location"
    t.string   "temporary_location"
    t.string   "location_status"
    t.integer  "restoration_code"
    t.string   "offsite_location_code"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["tape_id"], name: "index_inventory_statuses_on_tape_id", using: :btree
  end

  create_table "proofs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "record_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_proofs_on_record_id", using: :btree
  end

  create_table "records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "identifier"
    t.string   "title"
    t.integer  "extent"
    t.string   "extent_expression"
    t.integer  "collection_id"
    t.text     "abstract",            limit: 65535
    t.text     "note",                limit: 65535
    t.text     "citation",            limit: 65535
    t.text     "related_record_stmt", limit: 65535
    t.text     "identification_stmt", limit: 65535
    t.datetime "summary_date"
    t.datetime "cataloged_date"
    t.datetime "input_date"
    t.datetime "edited_date"
    t.datetime "corrected_date"
    t.datetime "produced_date"
    t.boolean  "has_mrc",                           default: false
    t.boolean  "has_paradox",                       default: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.index ["collection_id"], name: "index_records_on_collection_id", using: :btree
  end

  create_table "tapes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "record_id"
    t.string   "recording_type"
    t.integer  "number"
    t.string   "format"
    t.string   "source"
    t.datetime "date"
    t.string   "manufacturer"
    t.text     "note",           limit: 65535
    t.string   "condition_tape"
    t.string   "condition_odor"
    t.string   "condition_edge"
    t.string   "barcode"
    t.integer  "shared_with"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["record_id"], name: "index_tapes_on_record_id", using: :btree
  end

  create_table "terms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "record_id"
    t.integer  "authority_id"
    t.integer  "subject_authority_id"
    t.integer  "corporate_authority_id"
    t.integer  "person_authority_id"
    t.integer  "geographic_authority_id"
    t.integer  "genre_authority_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["authority_id"], name: "index_terms_on_authority_id", using: :btree
    t.index ["corporate_authority_id"], name: "index_terms_on_corporate_authority_id", using: :btree
    t.index ["genre_authority_id"], name: "index_terms_on_genre_authority_id", using: :btree
    t.index ["geographic_authority_id"], name: "index_terms_on_geographic_authority_id", using: :btree
    t.index ["person_authority_id"], name: "index_terms_on_person_authority_id", using: :btree
    t.index ["record_id"], name: "index_terms_on_record_id", using: :btree
    t.index ["subject_authority_id"], name: "index_terms_on_subject_authority_id", using: :btree
  end

end
