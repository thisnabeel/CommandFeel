class AddSocialMediaFieldsToScripts < ActiveRecord::Migration[7.0]
  def change
    add_column :scripts, :linkedin_body, :text
    add_column :scripts, :tiktok_body, :text
    add_column :scripts, :youtube_body, :text
    add_column :scripts, :youtube_title, :string
  end
end 