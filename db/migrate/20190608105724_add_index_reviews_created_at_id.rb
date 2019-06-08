class AddIndexReviewsCreatedAtId < ActiveRecord::Migration[5.2]
  def change
    add_index :reviews, [:created_at, :id]
  end
end
