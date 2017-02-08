class CreateInterviewees < ActiveRecord::Migration[5.0]
  def change
    create_table :interviewees do |t|
      t.references :interview, index: true
      t.string "name"
      t.timestamps
    end
  end
end
