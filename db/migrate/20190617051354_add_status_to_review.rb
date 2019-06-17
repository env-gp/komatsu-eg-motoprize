class AddStatusToReview < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :status, :integer, null: false
    add_index :reviews, :status
  end
end
