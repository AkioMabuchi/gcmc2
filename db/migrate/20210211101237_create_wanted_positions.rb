class CreateWantedPositions < ActiveRecord::Migration[6.0]
  def change
    create_table :wanted_positions do |t|
      t.integer :amount

      t.references :team, foreign_key: true
      t.references :name, foreign_key: {to_table: :position_names}
      t.timestamps
    end
  end
end
