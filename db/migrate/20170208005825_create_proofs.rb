class CreateProofs < ActiveRecord::Migration[5.0]
  def change
    create_table :proofs do |t|
      t.references :record, index: true
      # 'process'
      t.datetime   :date
      t.timestamps
    end
  end
end
