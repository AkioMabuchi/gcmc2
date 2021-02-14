class AddColumnsToUsers3 < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_email_notified, :boolean, default: true
  end
end
