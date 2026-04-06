# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# (compliance_officer/support_agent/compliance_manager/admin)
# Your own personal account
User.create!(
  first_name: "Emmanuel",
  last_name: "Vernet",
  email: "#{first_name.downcase}.#{last_name.downcase}@finversebank.com",
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
