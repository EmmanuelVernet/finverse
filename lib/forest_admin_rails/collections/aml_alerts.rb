module ForestAdminRails
  module Collections
    module AmlAlerts
      def self.customize(agent)
        # display customer_id as full customer name
        agent.collection :AmlAlert do |collection|
          collection.computed_field :customer_name,
            type: 'String',
            depends_on: [:customer_id] do |records|
              ids = records.map { |r| r['customer_id'] }
              customers = Customer.where(id: ids).index_by(&:id)
              records.map { |r| customers[r['customer_id']]&.company_name }
          end
        end
        # display bank account ID as bank account number
        agent.collection :AmlAlert do |collection|
          collection.computed_field :account_number,
            type: 'String',
            depends_on: [:bank_account_id] do |records|
              ids = records.map { |r| r['bank_account_id'] }
              bank_account = BankAccount.where(id: ids).index_by(&:id)
              records.map { |r| bank_account[r['bank_account_id']]&.account_number }
          end
        end
      end
    end
  end
end
