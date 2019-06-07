class Vehicle < ApplicationRecord
  belongs_to :maker
  has_many :reviews, dependent: :restrict_with_error
  has_many :users, through: :reviews

  validates :name, presence: true

  NO_IMAGE_PATH = "vehicles/no-image.png"

  scope :name_order_asc , -> { order(name: "ASC") }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def image?
    File.exist? "#{Rails.root}/app/assets/images/vehicles/#{self.id}.jpg"
  end

  def image_path
    "vehicles/#{self.id}.jpg"
  end

  def movie_split
    self.movie.split(',')
  end

  def maker
    Maker.find_by(id: self.maker_id)
  end
end