class CreateTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :terms do |t|
      t.references :record, index:true
      t.references :authority, index:true
      t.references :subject_authority, index:true
      t.references :corporate_authority, index:true
      t.references :person_authority, index:true
      t.references :geographic_authority, index:true
      t.references :genre_authority, index:true
      t.timestamps
    end
  end
end
