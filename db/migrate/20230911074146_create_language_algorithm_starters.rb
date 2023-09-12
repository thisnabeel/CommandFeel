class CreateLanguageAlgorithmStarters < ActiveRecord::Migration[7.0]
  def change
    create_table :language_algorithm_starters do |t|
      t.integer :programming_language_id
      t.integer :algorithm_id
      t.text :code
      t.json :code_lines
      t.string :video_url

      t.timestamps
    end
  end
end
