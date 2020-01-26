class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :reviews, dependent: :destroy
  has_many :vehicles, through: :reviews
  belongs_to :prefecture, optional: true

  DEFAULT_AVATER = "default_avater.jpg"

  validates :name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def thumbnail
    return self.avatar.variant(resize: '600x600').processed
  end

end
