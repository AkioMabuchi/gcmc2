class CreateContactMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_messages do |t|
      t.string :email
      t.string :title
      t.text :message

      t.timestamps
    end
  end
end
