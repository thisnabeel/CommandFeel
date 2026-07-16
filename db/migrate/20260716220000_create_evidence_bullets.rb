class CreateEvidenceBullets < ActiveRecord::Migration[7.0]
  def change
    create_table :evidence_bullets do |t|
      t.references :occupation_skill_evidence, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :evidence_bullets, [:occupation_skill_evidence_id, :position],
              name: 'index_evidence_bullets_on_evidence_and_position'
  end
end
