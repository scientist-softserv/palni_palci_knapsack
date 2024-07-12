# frozen_string_literal: true
module HykuKnapsack
  module NestedWorks
    extend ActiveSupport::Concern

    class_methods do
      def valid_child_concerns
        Hyrax.config.curation_concerns
      end
    end

    def valid_child_concerns
      Hyrax.config.curation_concerns
    end
  end
end
