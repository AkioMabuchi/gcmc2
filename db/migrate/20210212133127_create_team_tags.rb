class CreateTeamTags < ActiveRecord::Migration[6.0]
  def change
    create_table :team_tags do |t|
      t.references :team, foreign_key: true
      t.references :name, foreign_key: {to_table: :team_tag_names}

      t.timestamps
    end
  end
end
