class CreateCohortSprints < ActiveRecord::Migration[7.0]
  def up
    create_table :cohort_sprints do |t|
      t.references :cohort, null: false, foreign_key: true
      t.integer :position, null: false
      t.text :goal, null: false, default: ''
      t.boolean :active, null: false, default: false

      t.timestamps
    end

    add_index :cohort_sprints, [:cohort_id, :position], unique: true
    add_index :cohort_sprints, [:cohort_id, :active]

    # Backfill from existing sprints_count (default to 6 if blank/zero)
    say_with_time 'backfill cohort_sprints from sprints_count' do
      Cohort.reset_column_information
      Cohort.find_each do |cohort|
        count = [cohort.sprints_count.to_i, 1].max
        count.times do |i|
          CohortSprint.create!(
            cohort_id: cohort.id,
            position: i + 1,
            goal: '',
            active: i.zero?
          )
        end
      end
    end

    remove_column :cohorts, :sprints_count, :integer
  end

  def down
    add_column :cohorts, :sprints_count, :integer

    Cohort.reset_column_information
    Cohort.find_each do |cohort|
      cohort.update_columns(sprints_count: cohort.cohort_sprints.count)
    end

    drop_table :cohort_sprints
  end
end
