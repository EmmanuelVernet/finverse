class BankAccount < ApplicationRecord
  belongs_to :customer
  enum :status, { active: 0, frozen: 1, closed: 2 }, prefix: true
  validates :account_number, :currency, presence: true
end
