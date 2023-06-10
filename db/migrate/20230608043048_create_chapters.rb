class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.belongs_to :chapter, null: true, foreign_key: true
      t.string :title
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
