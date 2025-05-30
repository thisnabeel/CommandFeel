class AddSuggestedNameToProjectRequirementTools < ActiveRecord::Migration[7.0]
  def change
    add_column :project_requirement_tools, :suggested_name, :string
  end
end 