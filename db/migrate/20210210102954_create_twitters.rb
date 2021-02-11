class CreateTwitters < ActiveRecord::Migration[6.0]
  def change
    create_table :twitters do |t|
      t.string :uid
      t.string :url
      t.boolean :is_published_url, null:false, default:false

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
