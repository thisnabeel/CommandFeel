class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :title, null: false
      t.timestamps
    end

    add_index :tags, :title, unique: true
  end
end 