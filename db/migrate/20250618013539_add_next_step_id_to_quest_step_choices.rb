class AddNextStepIdToQuestStepChoices < ActiveRecord::Migration[7.0]
  def change
    add_reference :quest_step_choices, :next_step, null: true, foreign_key: { to_table: :quest_steps }
  end
end 