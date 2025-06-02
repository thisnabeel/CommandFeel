class CreatePhrases < ActiveRecord::Migration[7.0]
  def change
    create_table :phrases do |t|
      t.text :body, null: false
      t.string :role

      t.timestamps
    end
  end
end 