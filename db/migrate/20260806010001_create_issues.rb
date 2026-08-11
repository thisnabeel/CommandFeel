class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.references :cohort, null: false, foreign_key: true
      t.integer :number, null: false
      t.string :issue_type, null: false, default: 'task'
      t.string :status, null: false, default: 'todo'
      t.string :priority, null: false, default: 'medium'
      t.string :title, null: false
      t.text :description, null: false, default: ''
      t.references :cohort_sprint, null: true, foreign_key: true
      t.references :parent, null: true, foreign_key: { to_table: :issues }
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.references :assignee, null: true, foreign_key: { to_table: :users }
      t.decimal :backlog_rank, precision: 20, scale: 10, null: false, default: 0

      t.timestamps
    end

    add_index :issues, [:cohort_id, :number], unique: true
    add_index :issues, [:cohort_id, :backlog_rank]
    add_index :issues, [:cohort_id, :cohort_sprint_id]
    add_index :issues, [:cohort_id, :status]
    add_index :issues, [:cohort_id, :issue_type]
  end
end
