class DropFeatureTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :feature_dependencies do |t|
      t.references :feature, null: false, foreign_key: true
      t.references :dependable, polymorphic: true, null: false
      t.text :usage, null: false
      t.integer :position
      t.boolean :visibility, default: true
      t.timestamps
      t.index [:feature_id, :dependable_type, :dependable_id], unique: true, name: 'index_feature_dependencies_uniqueness'
      t.index :position
    end

    drop_table :wonder_features do |t|
      t.references :wonder, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.integer :position
      t.boolean :visibility, default: true
      t.timestamps
      t.index [:wonder_id, :feature_id], unique: true, name: 'index_wonder_features_uniqueness'
      t.index :position
    end

    drop_table :features do |t|
      t.string :title, null: false
      t.text :description
      t.integer :position
      t.boolean :visibility, default: true
      t.timestamps
      t.index :title
      t.index :position
    end
  end
end 