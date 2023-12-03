class CreateTradeOffAspects < ActiveRecord::Migration[7.0]
  def change
    create_table :trade_off_aspects do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.integer :trade_off_id

      t.timestamps
    end
  end
end
