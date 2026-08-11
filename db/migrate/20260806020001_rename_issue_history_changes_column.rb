class RenameIssueHistoryChangesColumn < ActiveRecord::Migration[7.0]
  def up
    return unless column_exists?(:issue_histories, :changes)
    return if column_exists?(:issue_histories, :change_set)

    rename_column :issue_histories, :changes, :change_set
  end

  def down
    return unless column_exists?(:issue_histories, :change_set)
    return if column_exists?(:issue_histories, :changes)

    rename_column :issue_histories, :change_set, :changes
  end
end
