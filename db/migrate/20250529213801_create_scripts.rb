class CreateScripts < ActiveRecord::Migration[7.0]
  def change
    create_table :scripts do |t|
      t.string :title, null: false
      t.text :body
      t.string :scriptable_type, null: false
      t.integer :scriptable_id, null: false
      t.integer :position

      t.timestamps
    end

    add_index :scripts, [:scriptable_type, :scriptable_id]
    add_index :scripts, :position
  end
end
