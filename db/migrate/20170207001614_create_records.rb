class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      # id: $910a
      # $910b
      t.string  "identifier", unique: true
      # $245[ahc]
      t.string  "title"
      # 'primary' 'Master Count'
      t.integer "extent"
      # $300 [physdesc][extent]
      t.string  "extent_expression"
      # 'primary' 'Collection'
      t.string  "collection"
      # $520
      t.text    "abstract"
      # $524 [prefercite]
      t.text    "citation"
      # $544 [relatedmaterial]
      t.text    "related_record_stmt"
      # $562 [relatedmaterial]
      t.text    "identification_stmt"

      # 'process' table
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

      t.boolean "has_mrc",     default: false
      t.boolean "has_paradox", default: false
      
      t.timestamps
    end
  end
end
