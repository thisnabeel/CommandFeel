class CreateJobStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :job_statuses do |t|
      t.string :job_type, null: false
      t.string :status, null: false
      t.datetime :started_at, null: false
      t.datetime :completed_at
      t.text :error_message

      t.timestamps
    end

    add_index :job_statuses, :job_type
    add_index :job_statuses, :status
    add_index :job_statuses, :started_at
  end
end 