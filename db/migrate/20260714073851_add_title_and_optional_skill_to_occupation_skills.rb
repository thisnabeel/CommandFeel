class AddTitleAndOptionalSkillToOccupationSkills < ActiveRecord::Migration[7.0]
  def change
    add_column :occupation_skills, :title, :string
    change_column_null :occupation_skills, :skill_id, true
  end
end
