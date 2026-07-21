class CreateCohortUserJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :cohort_user_jobs do |t|
      t.references :cohort_user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.integer :position, null: false, default: 0
      t.boolean :archive, null: false, default: false

      t.timestamps
    end

    add_index :cohort_user_jobs, [:cohort_user_id, :position],
              name: 'index_cohort_user_jobs_on_cohort_user_and_position'
  end
end
