class AmlAlert < ApplicationRecord
  belongs_to :customer
  belongs_to :bank_account
  belongs_to :triggering_transaction, class_name: "Transaction"
  belongs_to :reviewed_by, class_name: "User", optional: true

  enum :alert_type, { large_transfer: 0, unusual_pattern: 1, sanctioned_entity: 2 }
  enum :severity, { low: 0, medium: 1, high: 2, critical: 3 }
  enum :status, { open: 0, under_review: 1, escalated: 2, closed: 3 }
  validates :alert_type, :severity, :status, presence: true
end
