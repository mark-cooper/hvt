class CreateInventoryStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_statuses do |t|
      t.references :tape, index: true
      # 'cassette'
      t.string     :permanent_location
      t.string     :temporary_location
      t.string     :location_status
      t.integer    :restoration_code
      t.string     :offsite_location_code
      t.timestamps
    end
  end
end
