module ForestAdminRails
  class CreateAgent
    # def self.setup!
    #   database_configuration = Rails.configuration.database_configuration
    #   datasource = ForestAdminDatasourceActiveRecord::Datasource.new(database_configuration[Rails.env])

    #   @create_agent = ForestAdminAgent::Builder::AgentFactory.instance.add_datasource(datasource)
    #   customize
    #   @create_agent.build
    # end
    def self.setup!
      datasource = ForestAdminDatasourceActiveRecord::Datasource.new(
        ActiveRecord::Base.connection_db_config.configuration_hash
      )
      @create_agent = ForestAdminAgent::Builder::AgentFactory.instance.add_datasource(datasource)
      customize
      @create_agent.build
    end

    # smart actions customizations
    def self.customize
      # @create_agent.add_datasource....
      @create_agent.collection :onboarding_applications do |collection|
          # approve onboarding application
          collection.action 'Approve Application', scope: :single do
            execute do
              application = record(['id', 'status'])

              OnboardingApplication.find(application['id']).update!(
                status: 'approved',
                reviewed_at: Time.current
              )

              success 'Application approved successfully'
            end
          end

          # Reject onboarding application
          collection.action 'Reject Application', scope: :single do
            form do
              field :rejection_reason, type: :string, label: 'Rejection Reason', is_required: true
            end

            execute do
              application = record(['id'])
              reason = form_value(:rejection_reason)

              OnboardingApplication.find(application['id']).update!(
                status: 'rejected',
                rejection_reason: reason,
                reviewed_at: Time.current
              )

              success 'Application rejected'
            end
          end
        end
    end
  end
end
