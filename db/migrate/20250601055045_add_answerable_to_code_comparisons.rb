class AddAnswerableToCodeComparisons < ActiveRecord::Migration[7.0]
  def change
    add_reference :code_comparisons, :answerable, polymorphic: true, index: true
  end
end 