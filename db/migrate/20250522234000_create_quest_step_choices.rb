class CreateQuestStepChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :quest_step_choices do |t|
      t.references :quest_step, null: false, foreign_key: true
      t.text :body
      t.boolean :status, default: false
      t.integer :position

      t.timestamps
    end
  end
end 