class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :currency, null: false
      t.integer :transaction_type, null: false, default: 0  # debit=0, credit=1
      t.integer :status, null: false, default: 0  # pending=0, cleared=1, failed=2

      t.timestamps
    end
  end
end
