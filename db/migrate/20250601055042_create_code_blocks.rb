class CreateCodeBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :code_blocks do |t|
      t.text :content, null: false
      t.integer :position
      t.references :code_blockable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :code_blocks, [:code_blockable_type, :code_blockable_id, :position], 
              name: 'index_code_blocks_on_blockable_and_position'
  end
end 