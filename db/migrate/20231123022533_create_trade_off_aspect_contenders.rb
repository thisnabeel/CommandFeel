class CreateTradeOffAspectContenders < ActiveRecord::Migration[7.0]
  def change
    create_table :trade_off_aspect_contenders do |t|
      t.integer :trade_off_contender_id
      t.integer :trade_off_aspect_id
      t.text :body

      t.timestamps
    end
  end
end
