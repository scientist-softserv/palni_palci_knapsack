# frozen_string_literal: true

module HykuKnapsack
  class ActiveFedoraPropertyLocator
    attr_reader :klass, :properties

    def initialize(klass)
      @klass = klass
      locate
      generate_dynamic_methods
    end

    def from_app
      properties.select { |_k, file_path| from_root?(file_path) }
    end

    def from_gems
      properties.reject { |_k, file_path| from_root?(file_path) }
    end

    private

    # @return [Hash<Symbol, String>] a hash of property names and their file paths (with line numbers)
    # @example
    #  {:has_model=>"/usr/local/bundle/gems/active-fedora-14.0.1/lib/active_fedora/fedora_attributes.rb:15",
    #   :create_date=>"/usr/local/bundle/gems/active-fedora-14.0.1/lib/active_fedora/fedora_attributes.rb:16"}
    def locate
      @properties ||= klass.properties.keys.map(&:to_sym).index_with do |property_name|
        find_property_definition(klass, property_name)
      end
    end

    def find_property_definition(klass, property_name)
      klass.ancestors.each do |ancestor|
        next unless ancestor.name # Skip anonymous modules
        file_path, _line_num = Object.const_source_location(ancestor.name)
        next unless file_path

        File.read(file_path).force_encoding("UTF-8").scrub.each_line.with_index do |line, line_num|
          return "#{file_path}:#{line_num + 1}" if match_property_definition?(line, property_name)
        end
      end

      nil
    end

    def match_property_definition?(line, property_name)
      # TODO: If we get a nil as a file_path then we need to improve the regexp
      regexp = /^\s*(property|[\w.]+\.property)\s*\(?\s*:\s*#{property_name}\b/
      !line.strip.start_with?('#') && line.match?(regexp) # Skip commented lines
    end

    def from_root?(file_path)
      file_path.starts_with?(HykuKnapsack::Engine.root.to_s) || file_path.starts_with?(Rails.root.to_s)
    end

    def generate_dynamic_methods
      method_suffixes = properties.values.each_with_object([]) do |file_path, arr|
        next unless file_path
        suffix = file_path.split('/').last.split('.').first
        arr << suffix unless arr.include?(suffix)
      end

      method_suffixes.each do |suffix|
        self.class.define_method("from_#{suffix}") do
          properties.select { |_k, file_path| file_path.split('.rb').first.include?(suffix) }
        end
      end
    end
  end
end
