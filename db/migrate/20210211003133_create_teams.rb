class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :permalink
      t.string :name
      t.string :image
      t.string :title
      t.text :description

      t.references :owner_user, foreign_key: {to_table: :users}
      t.timestamps
    end
  end
end
