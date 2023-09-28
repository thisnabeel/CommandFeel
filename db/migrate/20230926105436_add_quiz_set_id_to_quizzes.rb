class AddQuizSetIdToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :quiz_set_id, :integer

  end
end
