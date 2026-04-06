class CreateAmlAlerts < ActiveRecord::Migration[8.1]
  def change
    create_table :aml_alerts do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :bank_account, null: false, foreign_key: true
      t.references :triggering_transaction, null: false, foreign_key: { to_table: :transactions }
      t.references :reviewed_by, null: false, foreign_key: { to_table: :users }
      t.integer :alert_type
      t.integer :severity
      t.integer :status
      t.text :notes

      t.timestamps
    end
  end
end
