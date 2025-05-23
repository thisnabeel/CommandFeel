class CreateCodeFlowElements < ActiveRecord::Migration[7.0]
  def change
    create_table :code_flow_elements do |t|
      t.string :title
      t.string :category

      t.timestamps
    end
  end
end
