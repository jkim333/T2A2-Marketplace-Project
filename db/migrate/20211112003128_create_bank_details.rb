class CreateBankDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_details do |t|
      t.string :name, default: ""
      t.string :account_number, default: ""
      t.string :bsb, default: ""
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
