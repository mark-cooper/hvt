class CreateAgents < ActiveRecord::Migration[5.0]
  def change
    create_table :agents do |t|
      t.string     :type
      t.string     :name
      t.timestamps
    end
    add_index :agents, [:type, :name], unique: true
  end
end
