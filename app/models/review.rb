class Review < ApplicationRecord

  TITLE_MAX_LENGTH = 30
  BODY_MAX_LENGTH = 2000
  HOME_PAGINATION_MAX = 2
  GALLERY_PAGINATION_MAX = 12
  REVIEWLIST_PAGINATION_MAX = 5
  DUPLICATE_REVIEW_ERR_MESSAGE = "すでに同一車種でレビューが投稿されています。投稿日:"

  STATUS_PUBLISH = 1
  STATUS_DRAFT = 2
  
  USES = [
    :touring,
    :race,
    :shopping,
    :commute,
    :work,
    :etcetera,
  ]

  has_one_attached :image

  has_many :likes, dependent: :destroy
  belongs_to :user
  belongs_to :vehicle
  
  validates :title, presence: true, on: :publish
  validates :title, length: { maximum: TITLE_MAX_LENGTH }
  validates :body, presence: true, on: :publish
  validates :body, length: { maximum: BODY_MAX_LENGTH }
  validate :validate_title_not_including_comma
  validate :validate_body_not_including_comma
  validate :validate_duplicate_review, on: :create
  
  scope :order_create_desc , -> (page, pagination_max) { where(status: STATUS_PUBLISH).order("created_at DESC, id DESC").page(page).per(pagination_max) }
  scope :review_includes , -> { Review.includes(:user, :vehicle) }
  
  def self.search(page, search: "", vehicle_id: nil, mode: nil)
    if mode == "gallerys"
      pagination_max = GALLERY_PAGINATION_MAX
    else
      pagination_max = HOME_PAGINATION_MAX
    end

    if search.length == 0
      if vehicle_id.nil?
        review_includes.order_create_desc(page, pagination_max)
      else
        review_includes.where(vehicle_id: vehicle_id).order_create_desc(page, pagination_max)
      end
    else
      # 検索文字列を空白で区切ってtitle, bodyそれぞれで検索する
      words = search.to_s.split(" ")
      search_words = words.map{ |word| "%#{word}%" }
      
      # gem 'activerecord-like'の機能を使用
      review_includes.where.like(title: search_words)
      .or(review_includes.where.like(body: search_words))
      .order_create_desc(page, pagination_max)
    end
  end
  
  # 車種選択画面でのレビュー重複チェック用
  def self.duplicate_review(user_id, vehicle_id)
    review = Review.find_by(user_id: user_id, vehicle_id: vehicle_id)
    if review
      DUPLICATE_REVIEW_ERR_MESSAGE + review.created_at.to_date.to_s
    end
  end
  
  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end
  
  private

  def validate_title_not_including_comma
    errors.add(:title, 'にカンマを含めることはできません') if title&.include?(',')
  end

  def validate_body_not_including_comma
    errors.add(:body, 'にカンマを含めることはできません') if body&.include?(',')
  end

  def validate_duplicate_review
    review = Review.find_by(user_id: self.user_id, vehicle_id: self.vehicle_id)
    if review
      errors[:base] << DUPLICATE_REVIEW_ERR_MESSAGE + review.created_at.to_date.to_s
    end
  end

  # Ransackの検索条件を絞る
  def self.ransackable_attributes(auth_object = nil)
    %w[title created_at]
  end

  # Ransackの検索時の関連にvehicleを含める
  def self.ransackable_associations(auth_object = nil)
    %w[vehicle]
  end
end
