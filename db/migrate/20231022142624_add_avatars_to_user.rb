class AddAvatarsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar_source_url, :string
    add_column :users, :avatar_cropped_url, :string
  end
end
