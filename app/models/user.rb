class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :products
  has_one :bank_detail
  accepts_nested_attributes_for :bank_detail
  has_many :purchases, class_name: 'Transaction', foreign_key: 'buyer_id'
  has_many :sales, class_name: 'Transaction', foreign_key: 'seller_id'

  validates :username, presence: { message: "can't be blank" },
            uniqueness: true, length: { maximum: 20 },
            format: { with: /\A[\S]+\z/,
              message: "can't have whitespace characters" }

  after_create do |user|
    p "*****************************************"
    BankDetail.create(user_id: user.id)
  end
end
