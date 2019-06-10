class ChangeNameOrderToMakers < ActiveRecord::Migration[5.2]
  def up
    change_column :makers, :name, :string, null: false
    change_column :makers, :order, :string, null: false
  end

  def down
    change_column :makers, :name, :string, null: true
    change_column :makers, :order, :string, null: true
  end
end
