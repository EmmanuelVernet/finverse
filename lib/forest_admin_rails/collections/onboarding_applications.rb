module ForestAdminRails
  module Collections
    module OnboardingApplications
      def self.customize(agent)
        # display customer_id as full customer name
        agent.collection :OnboardingApplication do |collection|
          collection.computed_field :company_name,
            type: 'String',
            depends_on: [:customer_id] do |records|
              ids = records.map { |r| r['customer_id'] }
              customers = Customer.where(id: ids).index_by(&:id)
              records.map { |r| customers[r['customer_id']]&.company_name }
          end
        end
      end
    end
  end
end
