class AddCodeLinesToChallenge < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :code, :text
    add_column :challenges, :code_lines, :json
  end
end
