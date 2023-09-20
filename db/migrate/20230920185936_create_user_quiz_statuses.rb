class CreateUserQuizStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_quiz_statuses do |t|
      t.integer :user_id, null: false
      t.integer :quiz_id, null: false
      t.integer :status

      t.timestamps
    end
  end
end
