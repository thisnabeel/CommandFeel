class CreateSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :skills do |t|
      t.string :title
      t.string :image
      t.text :description
      t.integer :difficulty
      t.integer :position
      t.belongs_to :skill, null: true, foreign_key: true
      t.boolean :visibility
      t.string :code
      t.string :slug
      t.boolean :is_course

      t.timestamps
    end
  end
end
