class CreateBankDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_details do |t|
      t.string :name
      t.string :account_number
      t.string :bsb
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
