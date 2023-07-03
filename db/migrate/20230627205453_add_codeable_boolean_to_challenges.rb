class AddCodeableBooleanToChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :codeable, :boolean, default: false
  end
end
