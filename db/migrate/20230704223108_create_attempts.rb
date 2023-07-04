class CreateAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table :attempts do |t|
      t.integer :algorithm_id
      t.integer :programming_language_id
      t.integer :user_id
      t.text :error_message
      t.boolean :passing

      t.timestamps
    end
  end
end
