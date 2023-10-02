class CreateSavedJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_jobs do |t|
      t.string :title
      t.string :company
      t.integer :position
      t.string :jd_link
      t.text :jd
      t.string :stage
      t.text :skills
      t.integer :user_id

      t.timestamps
    end
  end
end
