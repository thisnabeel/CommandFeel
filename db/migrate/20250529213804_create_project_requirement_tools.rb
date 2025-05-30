class CreateProjectRequirementTools < ActiveRecord::Migration[7.0]
  def change
    create_table :project_requirement_tools do |t|
      t.references :project_requirement, null: false, foreign_key: true
      t.references :toolable, polymorphic: true, null: false
      t.boolean :appropriate, default: true
      t.text :reason
      t.integer :position

      t.timestamps
    end

    add_index :project_requirement_tools, :position
    add_index :project_requirement_tools, [:toolable_type, :toolable_id], name: 'idx_proj_req_tools_on_toolable'
  end
end 