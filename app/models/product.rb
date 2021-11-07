class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :category

  has_many :transaction_details
  has_many :product_images

  validates :title, uniqueness: true
end
