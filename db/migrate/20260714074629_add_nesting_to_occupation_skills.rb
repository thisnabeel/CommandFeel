class AddNestingToOccupationSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :occupation_skills, :occupation_skill_id, :bigint
    add_column :occupation_skills, :position, :integer
    add_index :occupation_skills, :occupation_skill_id
    add_index :occupation_skills, [:occupation_id, :occupation_skill_id, :position],
              name: 'index_occupation_skills_on_parent_and_position'
    add_foreign_key :occupation_skills, :occupation_skills
  end
end
