class CreateInfrastructurePatterns < ActiveRecord::Migration[7.0]
  def change
    create_table :infrastructure_patterns do |t|
      t.string :title, null: false
      t.text :description
      t.integer :position
      t.boolean :visibility, default: true

      t.timestamps
    end

    create_table :wonder_infrastructure_patterns do |t|
      t.references :wonder, null: false, foreign_key: true
      t.references :infrastructure_pattern, null: false, 
                  foreign_key: true, 
                  index: { name: 'idx_wip_on_ip_id' }
      t.integer :position
      t.boolean :visibility, default: true

      t.timestamps
    end

    create_table :infrastructure_pattern_dependencies do |t|
      t.references :infrastructure_pattern, null: false, 
                  foreign_key: true,
                  index: { name: 'idx_ipd_on_ip_id' }
      t.references :dependable, polymorphic: true, null: false
      t.text :usage, null: false
      t.integer :position
      t.boolean :visibility, default: true

      t.timestamps
    end

    add_index :infrastructure_patterns, :title
    add_index :infrastructure_patterns, :position
    
    add_index :wonder_infrastructure_patterns, 
              [:wonder_id, :infrastructure_pattern_id], 
              unique: true, 
              name: 'idx_wip_uniqueness'
    add_index :wonder_infrastructure_patterns, :position

    add_index :infrastructure_pattern_dependencies,
              [:infrastructure_pattern_id, :dependable_type, :dependable_id],
              unique: true,
              name: 'idx_ipd_uniqueness'
    add_index :infrastructure_pattern_dependencies, :position
  end
end 