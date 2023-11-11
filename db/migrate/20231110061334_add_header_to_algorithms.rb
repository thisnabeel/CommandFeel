class AddHeaderToAlgorithms < ActiveRecord::Migration[7.0]
  def change
    add_column :algorithms, :header, :boolean, default: false
  end
end
