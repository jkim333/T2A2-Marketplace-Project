class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :seller, null: false, foreign_key: { to_table: :users }
      t.belongs_to :buyer, null: false, foreign_key: { to_table: :users }
      t.belongs_to :product, null: false, foreign_key: true
      t.integer :quantity
      t.integer :price

      t.timestamps
    end
  end
end
