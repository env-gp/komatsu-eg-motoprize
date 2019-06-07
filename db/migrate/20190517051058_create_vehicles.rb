class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string :name, null: false
      t.integer :maker_id, index: true, foreign_key: true

      t.timestamps
    end
  end
end
