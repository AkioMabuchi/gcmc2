class ChangeColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :birth
    add_column :users, :birth, :date, null: false, default: Date.parse("2000/01/01")
  end
end
