class CreateTestCases < ActiveRecord::Migration[7.0]
  def change
    create_table :test_cases do |t|
      t.integer :language_algorithm_starter_id
      t.text :code
      t.text :expectation
      t.integer :position

      t.timestamps
    end
  end
end
