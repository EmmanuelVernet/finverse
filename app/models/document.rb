class Document < ApplicationRecord
  belongs_to :onboarding_application

  validates :document_type, presence: true
  validates :file_url, presence: true
end
