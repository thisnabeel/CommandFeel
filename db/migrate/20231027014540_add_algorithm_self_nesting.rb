class AddAlgorithmSelfNesting < ActiveRecord::Migration[7.0]
  def change
    add_column :algorithms, :algorithm_id, :integer
    add_column :algorithms, :self_explanatory, :boolean
  end
end
