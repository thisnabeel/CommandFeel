class AddLevelToAbstractions < ActiveRecord::Migration[7.0]
  def change
    add_column :abstractions, :level, :integer, null: false, default: 0
    add_index :abstractions, [:abstractable_type, :abstractable_id, :level],
              name: 'index_abstractions_on_abstractable_and_level'
  end
end
