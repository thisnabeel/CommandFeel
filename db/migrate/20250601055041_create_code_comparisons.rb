class CreateCodeComparisons < ActiveRecord::Migration[7.0]
  def change
    create_table :code_comparisons do |t|
      t.string :title, null: false

      t.timestamps
    end
  end
end 