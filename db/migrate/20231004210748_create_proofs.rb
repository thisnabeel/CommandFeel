class CreateProofs < ActiveRecord::Migration[7.0]
  def change
    create_table :proofs do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
