class MakeQuestsPolymorphic < ActiveRecord::Migration[7.0]
  def up
    # Add new polymorphic columns
    add_column :quests, :questable_type, :string
    add_column :quests, :questable_id, :bigint

    # Copy existing skill relationships to new polymorphic columns
    execute <<-SQL
      UPDATE quests 
      SET questable_type = 'Skill', 
          questable_id = skill_id
      WHERE skill_id IS NOT NULL
    SQL

    # Remove the old foreign key and index
    remove_foreign_key :quests, :skills
    remove_index :quests, :skill_id if index_exists?(:quests, :skill_id)
    remove_column :quests, :skill_id

    # Add index for the new polymorphic columns
    add_index :quests, [:questable_type, :questable_id]
  end

  def down
    # Add back the original column
    add_column :quests, :skill_id, :bigint

    # Copy data back
    execute <<-SQL
      UPDATE quests 
      SET skill_id = questable_id 
      WHERE questable_type = 'Skill'
    SQL

    # Add back the foreign key and index
    add_index :quests, :skill_id
    add_foreign_key :quests, :skills

    # Remove polymorphic columns
    remove_index :quests, [:questable_type, :questable_id] if index_exists?(:quests, [:questable_type, :questable_id])
    remove_column :quests, :questable_type
    remove_column :quests, :questable_id
  end
end 