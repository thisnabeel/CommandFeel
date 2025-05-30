class CreateProjectRequirements < ActiveRecord::Migration[7.0]
  def change
    create_table :project_requirements do |t|
      t.references :wonder, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :position
      t.string :scale

      t.timestamps
    end

    add_index :project_requirements, :position
  end
end 