class AddReasoningToQuizChoices < ActiveRecord::Migration[7.0]
  def change
    add_column :quiz_choices, :reasoning, :text
  end
end 