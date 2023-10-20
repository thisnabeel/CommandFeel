class CreateProjectSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :project_skills do |t|
      t.integer :skill_id
      t.integer :project_id
      t.integer :position
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
