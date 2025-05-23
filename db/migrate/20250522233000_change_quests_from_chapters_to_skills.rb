class ChangeQuestsFromChaptersToSkills < ActiveRecord::Migration[7.0]
  def change
    remove_reference :quests, :chapter, foreign_key: true
    add_reference :quests, :skill, foreign_key: true
  end
end 