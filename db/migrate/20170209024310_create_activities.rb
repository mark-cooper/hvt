class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.references :record, index: true
      t.references :interview, index: true
      t.references :proof, index: true
      t.references :agent, index: true
      t.references :cataloger, index: true
      t.references :corrector, index: true
      t.references :editor, index: true
      t.references :inputter, index: true
      t.references :producer, index: true
      t.references :proofer, index: true
      t.references :summarizer, index: true
      t.references :interviewee, index: true
      t.references :interviewer, index: true
      t.timestamps
    end
  end
end
