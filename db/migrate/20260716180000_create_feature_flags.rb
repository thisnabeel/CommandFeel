class CreateFeatureFlags < ActiveRecord::Migration[7.0]
  def up
    create_table :feature_flags do |t|
      t.string :key, null: false
      t.boolean :enabled, null: false, default: false
      t.string :description

      t.timestamps
    end

    add_index :feature_flags, :key, unique: true

    FeatureFlag.create!(
      key: 'show_guide',
      enabled: false,
      description: 'Show the "New Here? Show Guide" floating button and guide overlays'
    )
  end

  def down
    drop_table :feature_flags
  end
end
