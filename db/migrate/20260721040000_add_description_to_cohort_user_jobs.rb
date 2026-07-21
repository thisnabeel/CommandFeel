class AddDescriptionToCohortUserJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :cohort_user_jobs, :description, :text
  end
end
