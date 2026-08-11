class AddIssueKeyPrefixToCohorts < ActiveRecord::Migration[7.0]
  def up
    add_column :cohorts, :issue_key_prefix, :string, null: false, default: 'PROJ'

    say_with_time 'backfill issue_key_prefix' do
      execute <<~SQL.squish
        UPDATE cohorts
        SET issue_key_prefix = UPPER(
          LEFT(
            REGEXP_REPLACE(COALESCE(title, ''), '[^A-Za-z0-9]', '', 'g'),
            4
          )
        )
        WHERE COALESCE(TRIM(title), '') <> ''
      SQL

      execute <<~SQL.squish
        UPDATE cohorts
        SET issue_key_prefix = 'PROJ'
        WHERE issue_key_prefix IS NULL OR TRIM(issue_key_prefix) = ''
      SQL
    end
  end

  def down
    remove_column :cohorts, :issue_key_prefix
  end
end
