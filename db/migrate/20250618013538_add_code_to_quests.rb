class AddCodeToQuests < ActiveRecord::Migration[7.0]
  def change
    add_column :quests, :code, :string
  end
end
