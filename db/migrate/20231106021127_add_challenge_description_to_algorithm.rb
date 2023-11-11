class AddChallengeDescriptionToAlgorithm < ActiveRecord::Migration[7.0]
  def change
    add_column :algorithms, :challenge_body, :text, default: ""
  end
end
