# frozen_string_literal: true

# OVERRIDE Hyrax v5.0.0 to add schemas that are located in config/metadata/*.yaml

module Hyrax
  module SimpleSchemaLoaderDecorator
    def config_search_paths
      [HykuKnapsack::Engine.root] + super
    end
  end
end

# This decorator being prepended in a before_initialize in engine.rb to ensure it's loaded first
