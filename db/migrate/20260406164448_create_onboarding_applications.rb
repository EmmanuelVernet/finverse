class CreateOnboardingApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :onboarding_applications do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :status, null: false, default: 0   # enum default
      t.string :application_type, null: false      # "kyc" or "kyb"
      t.datetime :reviewed_at
      t.references :reviewed_by, null: true, foreign_key: { to_table: :users }
      t.boolean :documents_verified, null: false, default: false
      t.text :rejection_reason

      t.timestamps
    end
  end
end
