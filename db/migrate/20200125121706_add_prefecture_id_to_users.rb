class AddPrefectureIdToUsers < ActiveRecord::Migration[5.2]
  def up
    add_reference :users, :prefecture, foreign_key: true
  end
  
  def down
    remove_reference :users, :prefecture
  end
end
