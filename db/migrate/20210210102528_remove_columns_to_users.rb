class RemoveColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :twitter_uid
    remove_column :users, :twitter_url
    remove_column :users, :is_published_twitter

    remove_column :users, :github_uid
    remove_column :users, :github_url
    remove_column :users, :is_published_github
  end
end
