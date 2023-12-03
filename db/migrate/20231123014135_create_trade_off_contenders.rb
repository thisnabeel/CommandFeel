class CreateTradeOffContenders < ActiveRecord::Migration[7.0]
  def change
    create_table :trade_off_contenders do |t|
      t.string :title
      t.integer :position
      t.integer :trade_off_id
      t.text :description
      t.integer :skill_id

      t.timestamps
    end
  end
end
