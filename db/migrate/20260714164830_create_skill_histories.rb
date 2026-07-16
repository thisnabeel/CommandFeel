class CreateSkillHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :skill_histories do |t|
      t.text :body
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
