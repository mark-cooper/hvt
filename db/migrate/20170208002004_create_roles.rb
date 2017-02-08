class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.references :record, index: true
      t.references :interview, index: true
      t.string     :type
      t.string     :name
      t.timestamps
    end
  end
end
