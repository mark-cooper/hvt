class CreateInterviews < ActiveRecord::Migration[5.0]
  def change
    create_table :interviews do |t|
      t.references :record, index: true
      t.datetime   :date
      t.timestamps
    end
  end
end
