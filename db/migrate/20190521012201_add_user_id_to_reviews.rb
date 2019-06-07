class AddUserIdToReviews < ActiveRecord::Migration[5.2]
  def up
    execute 'DELETE FROM reviews;'
    add_reference :reviews, :user, null: false, index: true
  end

  def down
    remove_reference :reviews, :user, index: true
  end
end
