class CreateAuthorities < ActiveRecord::Migration[5.0]
  def change
    create_table :authorities do |t|
      t.string     :type
      t.string     :name
      t.string     :source
      t.timestamps
    end
    add_index :authorities, [:type, :name], unique: true
  end
end
