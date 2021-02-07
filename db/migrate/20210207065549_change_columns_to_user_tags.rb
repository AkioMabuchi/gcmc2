class ChangeColumnsToUserTags < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_tags, :name_id
    remove_column :user_tags, :user_id

    add_reference :user_tags, :user, foreign_key: true
    add_reference :user_tags, :name, foreign_key: {to_table: :user_tag_names}
  end
end
