class BankDetail < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :account_number, presence: true
  validates :bsb, presence: true
end
