class ChangeUseToReview < ActiveRecord::Migration[5.2]
  class Review < ActiveRecord::Base
  end
  
  def up
    Review.reset_column_information
    Review.where(likes_count: nil).update_all(likes_count: 0)
    change_column :reviews, :likes_count, :integer, default: 0, null: false

    change_column :reviews, :touring, :boolean, default: false, null: false
    change_column :reviews, :race, :boolean, default: false, null: false
    change_column :reviews, :shopping, :boolean, default: false, null: false
    change_column :reviews, :commute, :boolean, default: false, null: false
    change_column :reviews, :work, :boolean, default: false, null: false
    change_column :reviews, :etcetera, :boolean, default: false, null: false
  end

  def down
    change_column :reviews, :likes_count, :integer, default: nil, null: true
    change_column :reviews, :touring, :boolean, default: nil, null: true
    change_column :reviews, :race, :boolean, default: nil, null: true
    change_column :reviews, :shopping, :boolean, default: nil, null: true
    change_column :reviews, :commute, :boolean, default: nil, null: true
    change_column :reviews, :work, :boolean, default: nil, null: true
    change_column :reviews, :etcetera, :boolean, default: nil, null: true
  end
end
