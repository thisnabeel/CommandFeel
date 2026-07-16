class AddResolvedToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :resolved, :boolean, null: false, default: false
    add_column :questions, :resolved_at, :datetime
    add_reference :questions, :resolved_by, foreign_key: { to_table: :users }, null: true
  end
end
