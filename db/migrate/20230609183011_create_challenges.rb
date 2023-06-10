class CreateChallenges < ActiveRecord::Migration[7.0]
  def change
    create_table :challenges do |t|
      t.integer :challengeable_id
      t.string :challengeable_type
      t.string :preview
      t.integer :position
      t.string :source_url
      t.text :body
      t.string :title

      t.timestamps
    end
  end
end
