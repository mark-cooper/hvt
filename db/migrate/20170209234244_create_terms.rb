class CreateTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :terms do |t|
      t.references :record, index:true
      t.references :authority, index:true
      t.references :subject, index:true
      t.timestamps
    end
  end
end
