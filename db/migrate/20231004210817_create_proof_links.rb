class CreateProofLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :proof_links do |t|
      t.integer :proof_id
      t.string :url
      t.string :title
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
