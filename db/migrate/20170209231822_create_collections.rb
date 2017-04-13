class CreateCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
      t.string   :name, unique: true
      t.integer  :extent, default: 0
      t.datetime :begin_date
      t.datetime :end_date
      t.timestamps
    end
  end
end
