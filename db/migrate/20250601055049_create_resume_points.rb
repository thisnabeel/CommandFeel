class CreateResumePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :resume_points do |t|
      t.text :body, null: false
      t.references :challenge, null: false, foreign_key: true
      t.integer :position, default: 1

      t.timestamps
    end

    add_index :resume_points, [:challenge_id, :position]
  end
end 