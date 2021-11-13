class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :category
  belongs_to :user

  has_many :sale_histories
  has_many :purchase_histories
  has_many :product_images

  validates :title, uniqueness: true

  self.per_page = 5
end
