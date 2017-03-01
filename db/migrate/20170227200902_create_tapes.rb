class CreateTapes < ActiveRecord::Migration[5.0]
  def change
    create_table :tapes do |t|
      t.references :record, index: true
      # 'cassette' 'Recoding type'
      t.string     :recording_type
      # 'cassette' 'Cassette number'
      t.integer    :number
      # 'cassette' 'Tape format'
      t.string     :format
      # 'cassette' 'Creation from'
      t.string     :source
      # 'cassette' 'Creation date'
      t.datetime   :date
      # 'cassette' 'Stock manufacturer'
      t.string     :manufacturer
      # 'cassette' 'Notes'
      t.text       :note
      # 'cassette' 'Tape wind'
      t.string     :condition_tape
      # 'cassette' 'Odor'
      t.string     :condition_odor
      # 'cassette' 'Edge damage'
      t.string     :condition_edge
      # 'cassette' 'Barcode'
      t.string     :barcode
      # 'cassette' 'Shared with' # use to fix barcodes
      t.integer    :shared_with
      t.timestamps
    end
  end
end
