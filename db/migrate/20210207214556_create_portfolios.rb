class CreatePortfolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios do |t|
      t.string :name
      t.string :image
      t.string :period
      t.text :description
      t.string :url

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
