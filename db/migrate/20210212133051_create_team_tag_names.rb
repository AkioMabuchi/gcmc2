class CreateTeamTagNames < ActiveRecord::Migration[6.0]
  def change
    create_table :team_tag_names do |t|
      t.string :name
      t.integer :sort_number

      t.timestamps
    end
  end
end
