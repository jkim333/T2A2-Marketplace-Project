class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :category
  belongs_to :user

  has_many :product_images
  has_many :comments
  has_many :transactions

  validates :title, presence: true
  validates :description, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  self.per_page = 5
end
