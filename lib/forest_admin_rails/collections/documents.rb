module ForestAdminRails
  module Collections
    module Documents
      def self.customize(agent)
        # display onboarding application ID as full customer name
        agent.collection :Document do |collection|
          collection.computed_field :company_name,
            type: 'String',
            depends_on: [:onboarding_application_id] do |records|
              ids = records.map { |r| r['onboarding_application_id'] }
              applications = OnboardingApplication.includes(:customer).where(id: ids).index_by(&:id)
                            records.map { |r| applications[r['onboarding_application_id']]&.customer&.company_name }
          end
        end
      end
    end
  end
end
