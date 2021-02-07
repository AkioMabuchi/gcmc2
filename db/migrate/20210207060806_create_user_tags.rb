class CreateUserTags < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tags do |t|
      t.bigint :user_id
      t.bigint :name_id

      t.timestamps
    end
  end
end
