class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      # id: $910a
      # $910b
      t.string     :identifier, unique: true
      # $245[ahc]
      t.string     :title
      # 'primary' 'Master Count'
      t.integer    :extent, default: 0
      # $300 [physdesc][extent]
      t.string     :extent_expression
      # 'primary' 'Master stock'
      t.string     :stock
      # $260b [origination creator]
      t.string     :primary_source
      # RAKE TASK (txt)
      t.string     :secondary_source
      # $260c [odd]
      t.string     :publication_date
      # $245f [unitdate]
      t.string     :date_expression
      # 'primary' 'Collection'
      t.references :collection, index:true
      # $520
      t.text       :abstract
      # 'process' 'Notes'
      t.text       :note
      # $524 [prefercite]
      t.text       :citation
      # $544 [relatedmaterial]
      t.text       :related_record_stmt
      # $562 [relatedmaterial]
      t.text       :identification_stmt
      # 'process' 'VoyagerKey'
      t.string     :bib_id

      # 'process' table
      t.datetime :summary_date
      t.datetime :cataloged_date
      t.datetime :input_date
      t.datetime :edited_date
      t.datetime :corrected_date
      t.datetime :produced_date

      t.boolean :has_mrc,     default: false
      t.boolean :has_paradox, default: false
      
      t.timestamps
    end
  end
end
