class Customer < ApplicationRecord
  enum :onboarding_status, { pending: 0, approved: 1, rejected: 2 } # gives helper methods like Customer.approved?
  validates :onboarding_status, presence: true
  validates :risk_score, inclusion: { in: 0..100 }

  # has_many :bank_accounts, dependent: :destroy
end
