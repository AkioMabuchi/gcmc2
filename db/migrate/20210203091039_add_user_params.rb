class AddUserParams < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :image, :string
    add_column :users, :description, :string, null: false, default: ""
    add_column :users, :url, :string, null: false, default:""
    add_column :users, :location, :string, null: false, default: ""
    add_column :users, :birth, :datetime, null: false, default: DateTime.parse("2000/01/01 12:00:00")
    add_column :users, :is_birth_published, :boolean, null: false, default: false
  end
end
