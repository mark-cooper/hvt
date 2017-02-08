class CreateInterviews < ActiveRecord::Migration[5.0]
  def change
    create_table :interviews do |t|
      t.references :record, index: true
      # 'persdata' 'Date of interview'
      t.datetime   :date
      # $245f
      t.string     :date_expression
      # 'persdata' 'Length of interview'
      t.string     :length
      t.timestamps
    end
  end
end
