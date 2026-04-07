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

    def self.customize
      # @create_agent.add_datasource....
    end
  end
end
