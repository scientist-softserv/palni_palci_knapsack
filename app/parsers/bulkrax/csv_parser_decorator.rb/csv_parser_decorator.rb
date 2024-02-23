# frozen_string_literal: true

# OVERRIDE BULKRAX 3.1.2 to include oer specific methods
module Bulkrax
  module CsvParserDecorator
    include OerCsvParser
    # @return [Array<String>]
    def required_elements
      if Bulkrax.fill_in_blank_source_identifiers
        %w[title resource_type]
      else
        ['title', 'resource_type', source_identifier]
      end
    end

    # remove required_elements?, missing_elements, and valid_import? if bulkrax
    # has been upgraded to version 5.2 or higher
    def required_elements?(record)
      missing_elements(record).blank?
    end

    def missing_elements(record)
      keys = keys_without_numbers(record.reject { |_, v| v.blank? }.keys.compact.uniq.map(&:to_s))
      return if keys.blank?

      required_elements.map(&:to_s) - keys.map(&:to_s)
    end

    def valid_import?
      compressed_record = records.map(&:to_a).flatten(1).partition { |_, v| !v }.flatten(1).to_h
      error_alert = "Missing at least one required element, missing element(s) are: #{missing_elements(compressed_record).join(', ')}"
      raise StandardError, error_alert unless required_elements?(compressed_record)

      file_paths.is_a?(Array)
    rescue StandardError => e
      status_info(e)
      false
    end
  end
end

Bulkrax::CsvParser.prepend(Bulkrax::CsvParserDecorator)
