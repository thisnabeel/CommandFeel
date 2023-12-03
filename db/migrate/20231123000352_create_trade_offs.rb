class CreateTradeOffs < ActiveRecord::Migration[7.0]
  def change
    create_table :trade_offs do |t|
      t.string :title
      t.integer :position
      t.boolean :header
      t.integer :trade_off_id

      t.timestamps
    end
  end
end
