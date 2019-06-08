class AddUseToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :touring, :boolean
    add_column :reviews, :race, :boolean
    add_column :reviews, :shopping, :boolean
    add_column :reviews, :commute, :boolean
    add_column :reviews, :work, :boolean
    add_column :reviews, :etcetera, :boolean
  end
end
