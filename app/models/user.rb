class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :transactions

  validates :username, presence: { message: "can't be blank" },
            uniqueness: true, length: { maximum: 20 },
            format: { with: /\A[\S]+\z/,
              message: "can't have whitespace characters" }
end
