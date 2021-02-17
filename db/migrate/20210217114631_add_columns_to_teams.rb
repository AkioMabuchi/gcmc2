class AddColumnsToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :using_language, :string, default: "", null: false
    add_column :teams, :platform, :string, default: "", null: false
    add_column :teams, :source_tool, :string, default: "", null: false
    add_column :teams, :communication_tool, :string, default: "", null: false
    add_column :teams, :project_tool, :string, default: "", null: false
    add_column :teams, :period, :string, default: "", null: false
    add_column :teams, :frequency, :string, default: "", null: false
    add_column :teams, :location, :string, default: "", null: false
  end
end
