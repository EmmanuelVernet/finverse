class OnboardingApplication < ApplicationRecord
  belongs_to :customer
  belongs_to :reviewed_by
end
