class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string     :type
      t.string     :name
      t.timestamps
    end
    add_index :roles, [:type, :name], unique: true
  end
end
