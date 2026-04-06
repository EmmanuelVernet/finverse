class Transaction < ApplicationRecord
  belongs_to :bank_account

  enum :transaction_type, { debit: 0, credit: 1 }
  enum :status, { pending: 0, cleared: 1, failed: 2 }

  validates :amount, numericality: { greater_than: 0 }
  validates :currency, presence: true
end
