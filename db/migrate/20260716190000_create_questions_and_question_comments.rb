class CreateQuestionsAndQuestionComments < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.references :last_comment_by, foreign_key: { to_table: :users }
      t.string :questionable_type, null: false
      t.bigint :questionable_id, null: false

      t.timestamps
    end

    add_index :questions, [:questionable_type, :questionable_id]
    add_index :questions, :user_id unless index_exists?(:questions, :user_id)

    create_table :question_comments do |t|
      t.text :body, null: false
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
