class AddColumnsToUsers2 < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :twitter_uid, :string
    add_column :users, :twitter_url, :string
    add_column :users, :is_published_twitter, :boolean

    add_column :users, :github_uid, :string
    add_column :users, :github_url, :string
    add_column :users, :is_published_github, :boolean
  end
end
