# Clean DB tables
puts "cleaning DB tables"
# User.delete_all
AmlAlert.delete_all
Transaction.delete_all
BankAccount.delete_all
Customer.delete_all
OnboardingApplication.delete_all
Document.delete_all
User.delete_all
puts "Cleaned DB table data"

# Your own personal account
puts "Creating users..."
admin = User.create!(
  first_name: "Emmanuel",
  last_name: "Vernet",
  email: "emmanuel.vernet@finversebank.com",
  role: "admin"
)

# Clara Dubois — compliance_manager
compliance_manager = User.create!(
  first_name: "Clara",
  last_name: "Dubois",
  email: "clara.dubois@finversebank.com",
  role: "compliance_manager"
)

# - Thomas Weber — compliance_officer
compliance_officer = User.create!(
  first_name: "Thomas",
  last_name: "Weber",
  email: "thomas.weber@finversebank.com",
  role: "compliance_officer"
)

# - Sofia Martin — support_agent
support_agent = User.create!(
  first_name: "Sofia",
  last_name: "Martin  ",
  email: "sofia.martin@finversebank.com",
  role: "support_agent"
)

puts "Created #{User.count} users"

# Customers
puts "Creating customers..."
# Alpha Consulting (Healthy SME)
alpha_consulting = Customer.create!(
  company_name: "Alpha Consulting",
  legal_name: "Alpha Consulting Ltd",
  registration_number: "REG1001",
  customer_type: "SME",
  email: "alpha@alpha.com",
  onboarding_status: :approved,
  risk_score: 22,
  country: "FR"
)
# Orion Trading Group (High Risk Enterprise)
orion_trading_group = Customer.create!(
  company_name: "Orion Trading Group",
  legal_name: "Orion Trading Group Ltd",
  registration_number: "REG1002",
  customer_type: "Enterprise",
  email: "orion@orion.com",
  onboarding_status: :approved,
  risk_score: 88,
  country: "DE"
)
# NovaTech Labs (Pending)
novatech_labs = Customer.create!(
  company_name: "NovaTech Labs",
  legal_name: "NovaTech Labs Ltd",
  registration_number: "REG1003",
  customer_type: "SME",
  email: "nova@nova.com",
  onboarding_status: :pending,
  risk_score: 45,
  country: "US"
)
# Baltic Export Ltd (Rejected)
baltic_export = Customer.create!(
  company_name: "Baltic Export",
  legal_name: "Baltic Export Ltd",
  registration_number: "REG1004",
  customer_type: "SME",
  email: "baltic@baltic.com",
  onboarding_status: :rejected,
  risk_score: 72,
  country: "LT"
)
# Helios Energy Corp (Large Enterprise)
helios_energy = Customer.create!(
  company_name: "Helios Energy Corp",
  legal_name: "Helios Energy Corp Ltd",
  registration_number: "REG1005",
  customer_type: "Enterprise",
  email: "helios@helios.com",
  onboarding_status: :approved,
  risk_score: 40,
  country: "US"
)
puts "Created #{Customer.count} customers"

# Create Onboarding Applications
puts "Creating Onboarding applications..."

alpha_application = OnboardingApplication.create!(
  customer: alpha_consulting,
  status: :approved,
  application_type: "kyc",
  reviewed_by: compliance_manager,
  reviewed_at: Time.current,
  documents_verified: true
)

orion_application = OnboardingApplication.create!(
  customer: orion_trading_group,
  status: :approved,
  application_type: "kyb",
  reviewed_by: compliance_manager,
  reviewed_at: Time.current,
  documents_verified: true
)

novatech_application = OnboardingApplication.create!(
  customer: novatech_labs,
  status: :under_review,
  application_type: "kyc",
  reviewed_by: compliance_manager,
  reviewed_at: Time.current,
  documents_verified: false
)

baltic_application = OnboardingApplication.create!(
  customer: baltic_export,
  status: :rejected,
  application_type: "kyc",
  reviewed_by: compliance_manager,
  reviewed_at: Time.current,
  rejection_reason: "Insufficient documentation",
  documents_verified: false
)

helios_application = OnboardingApplication.create!(
  customer: helios_energy,
  status: :approved,
  application_type: "kyb",
  reviewed_by: compliance_manager,
  reviewed_at: Time.current,
  documents_verified: true
)
puts "Created #{OnboardingApplication.count} onboarding applications"

# Create Documents
puts "Creating Documents..."
# approved companies
Document.create!(
  onboarding_application: alpha_application,
  document_type: "certificate_of_incorporation",
  file_url: "https://example.com/certificate_of_incorporation.pdf",
  verified: true
)
# under review
Document.create!(
  onboarding_application: novatech_application,
  document_type: "passport",
  file_url: "https://example.com/passport.pdf",
  verified: false
)
# rejected companies
Document.create!(
  onboarding_application: baltic_application,
  document_type: "passport",
  file_url: "https://example.com/passport.pdf",
  verified: false
)

Document.create!(
  onboarding_application: orion_application,
  document_type: "certificate_of_incorporation",
  file_url: "https://example.com/orion_certificate.pdf",
  verified: true
)
Document.create!(
  onboarding_application: helios_application,
  document_type: "certificate_of_incorporation",
  file_url: "https://example.com/helios_certificate.pdf",
  verified: true
)
puts "Created #{Document.count} documents"

# BankAccounts
puts "Creating Bank accounts..."
[ alpha_consulting, orion_trading_group, helios_energy ].each do |customer|
  2.times do |i|
    BankAccount.create!(
      customer: customer,
      account_number: "ACC#{customer.company_name.first(3).upcase}-#{i + 1}",
      currency: [ "EUR", "USD" ].sample,
      status: :active,
      current_balance: rand(1000..100_000).to_f
    )
  end
end
puts "Created #{BankAccount.count} bank accounts"

# Transactions
puts "Creating transactions..."
BankAccount.all.each do |account|
    Transaction.create!(
      bank_account: account,
      # amount: rand(10..10_000).to_f,
      amount: 1_000.00,
      currency: account.currency,
      transaction_type: :credit,
      status: :cleared
    )
    Transaction.create!(
      bank_account: account,
      amount: 2_500.00,
      currency: account.currency,
      transaction_type: :debit,
      status: :cleared
    )
end
puts "Created #{Transaction.count} transactions"

# AMLAlerts
puts "Creating AML Alerts..."
# Transaction.all.sample(5).each do |txn|
#   AmlAlert.create!(
#     customer: txn.bank_account.customer,
#     bank_account: txn.bank_account,
#     triggering_transaction: txn,
#     reviewed_by: User.first,
#     alert_type: ["large_transfer", "unusual_pattern", "sanctioned_entity"].sample,
#     severity: ["low", "medium", "high", "critical"].sample,
#     status: ["open", "under_review", "escalated", "closed"].sample,
#     notes: "Generated for seeding"
#   )
# end
orion_account = BankAccount.where(customer: orion_trading_group).first
orion_txn = orion_account.transactions.first
large_txn = Transaction.create!(
  bank_account: orion_account,
  amount: 95_000.00,
  currency: orion_account.currency,
  transaction_type: :debit,
  status: :pending
)

AmlAlert.create!(
  customer: orion_trading_group,
  bank_account: orion_account,
  triggering_transaction: large_txn,
  reviewed_by: compliance_officer,
  alert_type: :large_transfer,
  severity: :high,
  status: :open,
  notes: "Large transfer flagged for review"
)
puts "Created #{AmlAlert.count} AML Alerts"
