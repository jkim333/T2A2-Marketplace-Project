class CreateTransactionHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_histories do |t|
      t.string :sort
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
