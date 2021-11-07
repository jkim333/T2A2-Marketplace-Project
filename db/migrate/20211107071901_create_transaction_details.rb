class CreateTransactionDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_details do |t|
      t.integer :quantity
      t.references :transaction_history, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
