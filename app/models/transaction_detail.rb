class TransactionDetail < ApplicationRecord
  belongs_to :transaction_history
  belongs_to :product
end
