module ForestAdminRails
  module Collections
    module Customers
      def self.customize(agent)
        # risk level badge
        agent.collection :Customer do |collection|
          collection.computed_field :risk_level,
            type: 'String',
            depends_on: [:risk_score] do |records|
              records.map do |r|
                score = r['risk_score']
                if score >= 75 then 'High Risk'
                elsif score >= 40 then 'Medium Risk'
                else 'Low Risk'
                end
              end
            end

            # customer alert count badge
          collection.computed_field :alert_count,
            type: 'Number',
            depends_on: [:id] do |records|
              ids = records.map { |r| r['id'] }
              counts = AmlAlert.where(customer_id: ids).group(:customer_id).count
              records.map { |r| counts[r['id']] || 0 }
            end
        end
      end
    end
  end
end
