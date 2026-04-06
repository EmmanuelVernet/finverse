# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clean DB tables
puts "cleaning DB tables"
User.delete_all
puts "Cleaned DB table data"

# Your own personal account
puts "Creating users..."
User.create!(
  first_name: "Emmanuel",
  last_name: "Vernet",
  email: "emmanuel.vernet@finversebank.com",
  role: "admin"
)

4.times do |i|
  first_name = Faker::Name.first_name
  last_name  = Faker::Name.last_name

  User.create!(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name.downcase}.#{last_name.downcase}@finversebank.com",
    role: [ "compliance_officer", "support_agent", "compliance_manager", "admin" ].sample
  )
end

puts "Created #{User.count} users"

# Customers
puts "Creating customers..."
5.times do |i|
  Customer.create!(
    company_name: "Company #{i}",
    legal_name: "Company #{i} Ltd",
    registration_number: "REG#{1000 + i}",
    customer_type: ["SME", "Enterprise"].sample,
    email: "customer#{i}@example.com",
    onboarding_status: :approved,
    risk_score: rand(0..100),
    country: ["FR", "DE", "US"].sample
  )
end
puts "Created #{Customer.count} customers"

# BankAccounts
puts "Creating Bank accounts..."
Customer.all.each do |customer|
  2.times do
    BankAccount.create!(
      customer: customer,
      account_number: "FR#{rand(10**22..10**23 - 1)}",
      currency: ["EUR", "USD"].sample,
      status: :active,
      current_balance: rand(1000..100_000).to_f
    )
  end
end
puts "Created #{Customer.count} customers"

# Transactions
puts "Creating transactions..."
BankAccount.all.each do |account|
  5.times do
    Transaction.create!(
      bank_account: account,
      amount: rand(10..10_000).to_f,
      currency: account.currency,
      transaction_type: ["debit", "credit"].sample,
      status: ["pending", "cleared", "failed"].sample
    )
  end
end
puts "Created #{Transaction.count} transactions"

# AMLAlerts
puts "Creating AML Alerts..."
Transaction.all.sample(5).each do |txn|
  AmlAlert.create!(
    customer: txn.bank_account.customer,
    bank_account: txn.bank_account,
    triggering_transaction: txn,
    reviewed_by: User.first, # or nil
    alert_type: ["large_transfer", "unusual_pattern", "sanctioned_entity"].sample,
    severity: ["low", "medium", "high", "critical"].sample,
    status: ["open", "under_review", "escalated", "closed"].sample,
    notes: "Generated for seeding"
  )
end
puts "Created #{AmlAlert.count} AML Alerts"
