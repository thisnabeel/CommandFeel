class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
