class OnboardingApplication < ApplicationRecord
  belongs_to :customer
  belongs_to :reviewed_by, class_name: "User", optional: true
  has_many :documents, dependent: :destroy

  enum :status, { draft: 0, submitted: 1, under_review: 2, approved: 3, rejected: 4 }

  validates :application_type, inclusion: { in: %w[kyc kyb] }
end
