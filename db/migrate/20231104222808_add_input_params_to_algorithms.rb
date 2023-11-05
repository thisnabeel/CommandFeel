class AddInputParamsToAlgorithms < ActiveRecord::Migration[7.0]
  def change
    add_column :algorithms, :input_params, :json, default: []
    add_column :algorithms, :test_cases, :json, default: []
  end
end
