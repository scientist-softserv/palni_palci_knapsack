# frozen_string_literal: true

# OVERRIDE Hyrax v5.0.0 to move HykuKnapsack's scheme_org.yml over the submodule's

module Hyrax
  module MicrodataDecorator
    FILENAME = HykuKnapsack::Engine.root + 'config/schema_org.yml'

    def load_paths
      [FILENAME] + super
    end
  end
end

Hyrax::Microdata.singleton_class.send(:prepend, Hyrax::MicrodataDecorator)
