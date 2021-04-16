class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.boolean :is_read, default: false, null: false

      t.references :sender_user, foreign_key: {to_table: :users}
      t.references :receiver_user, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
