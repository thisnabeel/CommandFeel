class AddPositionToAlgorithms < ActiveRecord::Migration[7.0]
  def change
    add_column :algorithms, :position, :integer, default: 1

  end
end
