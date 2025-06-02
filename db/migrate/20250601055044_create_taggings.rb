class CreateTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :taggable, polymorphic: true, null: false
      t.timestamps
    end

    # Add a unique index to prevent duplicate taggings
    add_index :taggings, [:tag_id, :taggable_type, :taggable_id], unique: true, name: 'index_taggings_uniqueness'
  end
end 