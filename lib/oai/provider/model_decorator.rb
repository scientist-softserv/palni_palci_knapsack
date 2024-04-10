# frozen_string_literal: true

module HykuKnapsack
  module OAI
    module Provider
      module ModelDecorator
        # Map Qualified Dublin Core (Terms) fields to PALNI/PALCI fields
        # rubocop:disable Metrics/MethodLength
        def map_oai_hyku
          super.reject { |key, _| %i[owner date_modified date_uploaded depositor].include?(key) }
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end

OAI::Provider::Model.prepend(HykuKnapsack::OAI::Provider::ModelDecorator)
