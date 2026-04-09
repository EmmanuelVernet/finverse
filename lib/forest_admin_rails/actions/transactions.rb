module ForestAdminRails
  module Actions
    module Transactions
      def self.customize(agent)
        agent.collection :Transaction do |collection|
          # Mark transaction as suspicious
          collection.action 'Mark as Suspicious', scope: :single do
            form do
              field :alert_type, type: :enum, label: 'Alert Type',
                options: ['large_transfer', 'unusual_pattern', 'sanctioned_entity'],
                is_required: true
              field :severity, type: :enum, label: 'Severity',
                options: ['low', 'medium', 'high', 'critical'],
                is_required: true
              field :description, type: :string, label: 'Description'
            end

            execute do
              t = record(['id', 'bank_account_id'])

              bank_account = BankAccount.find(t['bank_account_id'])

              AmlAlert.create!(
                transaction_id: t['id'],
                bank_account_id: t['bank_account_id'],
                customer_id: bank_account.customer_id,
                alert_type: form_value(:alert_type),
                risk_level: form_value(:risk_level),
                notes: form_value(:notes),
                status: 'open',
                triggered_at: Time.current
              )
              success 'Transaction flagged and AML alert created'
            end
          end
        end
      end
    end
  end
end
