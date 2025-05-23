class CreateLeetcodeProblems < ActiveRecord::Migration[7.0]
  def change
    create_table :leetcode_problems do |t|
      t.string :title
      t.text :description
      t.string :difficulty
      t.string :url
      t.string :topics

      t.timestamps
    end
  end
end
