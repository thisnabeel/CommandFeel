class CreateWonders < ActiveRecord::Migration[7.0]
  def change
    create_table :wonders do |t|
      t.string :title
      t.string :image
      t.text :description
      t.integer :difficulty
      t.integer :position
      t.bigint :wonder_id
      t.boolean :visibility
      t.string :code
      t.string :slug
      t.boolean :is_course

      t.timestamps
    end

    add_index :wonders, :wonder_id
    add_foreign_key :wonders, :wonders
  end
end 