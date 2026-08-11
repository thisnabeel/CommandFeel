class CreateIssueHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_histories do |t|
      t.references :issue, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :event, null: false, default: 'updated'
      t.jsonb :change_set, null: false, default: []

      t.timestamps
    end

    add_index :issue_histories, [:issue_id, :created_at]
  end
end
