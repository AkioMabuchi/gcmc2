class CreateJoinRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :join_requests do |t|
      t.text :message

      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.references :position_name, foreign_key: true
      t.timestamps
    end
  end
end
