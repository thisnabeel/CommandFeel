class AddStatusToCohortUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :cohort_users, :status, :string, null: false, default: 'open'

    remove_index :cohort_users, name: 'index_cohort_users_on_cohort_id_and_user_id'
    add_index :cohort_users, [:cohort_id, :user_id],
              unique: true,
              where: 'user_id IS NOT NULL',
              name: 'index_cohort_users_on_cohort_id_and_user_id_unique'
  end

  def down
    remove_index :cohort_users, name: 'index_cohort_users_on_cohort_id_and_user_id_unique'
    add_index :cohort_users, [:cohort_id, :user_id],
              name: 'index_cohort_users_on_cohort_id_and_user_id'

    remove_column :cohort_users, :status
  end
end
