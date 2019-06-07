class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review, counter_cache: :likes_count

  MYPAGE_LIKE_PAGINATION_MAX = 3

  def self.likes(page, user)
    Like.includes(:review, :user)
    .where("reviews.user_id = ?", user.id).references(:reviews)
    .order("likes.created_at DESC")
    .page(page)
    .per(MYPAGE_LIKE_PAGINATION_MAX)
  end
end
