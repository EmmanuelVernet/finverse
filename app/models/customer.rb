class Customer < ApplicationRecord
  validates :onboarding_status, presence: true
  validates :risk_score, inclusion: { in: 0..100 }

  enum onboarding_status: { pending: 0, approved: 1, rejected: 2 } # gives helper methods like Customer.approved?
end
