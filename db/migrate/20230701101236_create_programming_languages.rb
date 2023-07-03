class CreateProgrammingLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :programming_languages do |t|
      t.string :title
      t.integer :position
      t.string :editor_slug

      t.timestamps
    end
  end
end
