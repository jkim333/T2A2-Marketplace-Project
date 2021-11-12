class CreateSaleHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :sale_histories do |t|
      t.integer :quantity
      t.integer :price
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
