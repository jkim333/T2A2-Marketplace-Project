class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.integer :price
      t.integer :stock
      t.integer :views, default: 0
      t.boolean :listed
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
