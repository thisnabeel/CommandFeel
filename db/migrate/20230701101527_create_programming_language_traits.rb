class CreateProgrammingLanguageTraits < ActiveRecord::Migration[7.0]
  def change
    create_table :programming_language_traits do |t|
      t.integer :programming_language_id
      t.integer :trait_id
      t.text :body

      t.timestamps
    end
  end
end
