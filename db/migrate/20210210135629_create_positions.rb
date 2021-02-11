class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.references :user, foreign_key: true
      t.references :name, foreign_key: {to_table: :position_names}

      t.timestamps
    end
  end
end
