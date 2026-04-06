class CreateBankAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :bank_accounts do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :account_number, null: false
      t.string :currency, null: false
      t.integer :status, null: false, default: 0 # active/frozen/closed
      t.decimal :current_balance, precision: 15, scale: 2, null: false, default: 0.0

      t.timestamps
    end
  end
end
