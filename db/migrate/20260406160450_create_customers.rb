class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers do |t|
      t.string :company_name
      t.string :legal_name
      t.string :registration_number
      t.string :customer_type
      t.string :email
      t.integer :onboarding_status
      t.integer :risk_score
      t.string :country

      t.timestamps
    end
  end
end
