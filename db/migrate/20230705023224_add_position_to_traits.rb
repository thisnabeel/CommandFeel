class AddPositionToTraits < ActiveRecord::Migration[7.0]
  def change
    add_column :traits, :position, :integer, default: 1
  end
end
