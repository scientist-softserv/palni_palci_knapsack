# frozen_string_literal: true

# OVERRIDE Hyrax v5.0.0 to add custom relations to the change_set

module Hyrax
  module Transactions
    module ContainerDecorator
      extend Dry::Container::Mixin

      namespace 'change_set' do |ops|
        ops.register "add_custom_relations" do
          HykuKnapsack::Steps::AddCustomRelations.new
        end
      end
    end
  end
end

Hyrax::Transactions::Container.merge(Hyrax::Transactions::ContainerDecorator)
