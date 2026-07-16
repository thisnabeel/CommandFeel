class CreateOccupationSkillUserNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :occupation_skill_user_notes do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :occupation_skill, null: false, foreign_key: true

      t.timestamps
    end

    add_index :occupation_skill_user_notes, [:user_id, :occupation_skill_id],
              unique: true,
              name: 'index_os_user_notes_on_user_and_occupation_skill'
  end
end
