class CreateOccupationSkillEvidences < ActiveRecord::Migration[7.0]
  def change
    create_table :occupation_skill_evidences do |t|
      t.text :body, null: false
      t.boolean :approved, null: false, default: false
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.references :occupation_skill, null: false, foreign_key: true
      t.references :cohort, null: true, foreign_key: true

      t.timestamps
    end

    add_index :occupation_skill_evidences, [:occupation_skill_id, :user_id],
              name: 'index_evidences_on_skill_and_user'
  end
end
