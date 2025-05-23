class CreateComprehensionQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :comprehension_questions do |t|
      t.references :leetcode_problem, null: false, foreign_key: true
      t.text :question
      t.text :answer
      t.string :question_type

      t.timestamps
    end
  end
end
