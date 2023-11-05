class AddAlgorithmForeignKeyToTestCase < ActiveRecord::Migration[7.0]
  def change
    add_column :test_cases, :algorithm_id, :integer
  end
end
