class Maker < ApplicationRecord
  has_many :vehicles

  has_one_attached :image

  validates :name, presence: true
  validates :order, presence: true

  scope :order_asc , -> { order(order: "ASC") }
end
