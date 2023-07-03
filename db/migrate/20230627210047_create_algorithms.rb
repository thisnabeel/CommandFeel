class CreateAlgorithms < ActiveRecord::Migration[7.0]
  def change
    create_table :algorithms do |t|
      t.string :title
      t.text :description
      t.text :expected
      t.integer :difficulty

      t.timestamps
    end
  end
end
