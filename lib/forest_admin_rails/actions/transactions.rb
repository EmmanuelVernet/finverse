module ForestAdminRails
  module Actions
    module Transactions
      def self.customize(agent)
        agent.collection :Transaction do |collection|
          # Mark transaction as suspicious
          collection.action 'Mark as Suspicious', scope: :single do
            form do
              field :alert_type, type: :enum,
                enum_values: ['large_transfer', 'unusual_pattern', 'sanctioned_entity'],
                required: true
              field :severity, type: :enum,
                enum_values: ['low', 'medium', 'high', 'critical'],
                required: true
              field :notes, type: :string
            end

            execute do
              t = record(['id', 'bank_account_id'])

              # Safely get form values with fallbacks
              alert_type = form_value("alert_type")
                severity   = form_value("severity")
              notes      = form_value("notes")

              bank_account = BankAccount.find(t['bank_account_id'])

              AmlAlert.create!(
                triggering_transaction_id: t['id'],
                bank_account_id: t['bank_account_id'],
                customer_id: bank_account.customer_id,
                alert_type:  alert_type,
                severity:  severity,
                notes: notes,
                status: 0,
                reviewed_by_id: 4
              )
              success 'Transaction flagged and AML alert created'
            end
          end
        end
      end
    end
  end
end
