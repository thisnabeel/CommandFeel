class AddReasoningToQuestStepChoices < ActiveRecord::Migration[7.0]
  def change
    add_column :quest_step_choices, :reasoning, :text
  end
end 