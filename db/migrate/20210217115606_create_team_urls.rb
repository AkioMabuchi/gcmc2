class CreateTeamUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :team_urls do |t|
      t.string :name
      t.string :url
      t.boolean :is_public, default: false, null: false

      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
