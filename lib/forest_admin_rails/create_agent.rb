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
      # require submodules for Actions
      require_relative 'actions/transactions'

      # require submodules for customizations
      require_relative 'collections/customers'
      require_relative 'collections/onboarding_applications'
      require_relative 'collections/aml_alerts'
      require_relative 'collections/documents'

      # SMART ACTIONS
      # Onboarding actions
      @create_agent.collection :OnboardingApplication do |collection|
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
            field :rejection_reason, type: "String", required: true
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

      # AML actions
      @create_agent.collection :AmlAlert do |collection|
        # set AML alert status to escalated
        collection.action 'Escalate Alert', scope: :single do
          form do
            field :notes, type: "String", required: true
          end
          execute do
            application = record(['id', 'status'])
            reason = form_value(:notes)

            AmlAlert.find(application['id']).update!(
              status: 'escalated',
              notes: reason,
              # reviewed_by: optional param.how can I assign a user in FA and not in DB?
            )
            success 'Alert escalated'
          end
        end

        # set AML alert status to closed
        collection.action 'Close Alert', scope: :single do
          form do
            field :notes, type: "String", required: true
          end
          execute do
            application = record(['id'])
            reason = form_value(:notes)

            AmlAlert.find(application['id']).update!(
              status: 'closed',
              notes: reason,
              # reviewed_by: optional param.how can I assign a user in FA and not in DB?
            )
            success 'Alert closed'
          end
        end
      end

      # Bank account Freeze/Unfreeze & Closed
      @create_agent.collection :BankAccount do |collection|
        # set Bank account status to frozen
        collection.action 'Freeze account', scope: :single do
          execute do
            application = record(['id', 'status'])

            BankAccount.find(application['id']).update!(
              status: 'frozen',
            )
            success 'Account frozen'
          end
        end

        # set Bank account status to active
        collection.action 'Unfreeze account', scope: :single do
          execute do
            application = record(['id'])

            BankAccount.find(application['id']).update!(
              status: 'active',
            )
            success 'Account active'
          end
        end

        # set Bank account status to closed
        collection.action 'Close account', scope: :single do
          execute do
            application = record(['id'])

            BankAccount.find(application['id']).update!(
              status: 'closed',
            )
            success 'Account closed!'
          end
        end

        # reopen Bank account
        collection.action 'Reopen account', scope: :single do
          execute do
            application = record(['id'])

            BankAccount.find(application['id']).update!(
              status: 'active',
            )
            success 'Account reopened!'
          end
        end
      end

      # Other Smart actions
      Actions::Transactions.customize(@create_agent)

      # Smart fields
      Collections::Customers.customize(@create_agent)
      Collections::OnboardingApplications.customize(@create_agent)
      Collections::AmlAlerts.customize(@create_agent)
      Collections::Documents.customize(@create_agent)
    end
  end
end
