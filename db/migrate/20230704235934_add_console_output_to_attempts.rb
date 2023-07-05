class AddConsoleOutputToAttempts < ActiveRecord::Migration[7.0]
  def change
    add_column :attempts, :console_output, :text, default: ""
  end
end
