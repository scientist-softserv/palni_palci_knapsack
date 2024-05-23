# frozen_string_literal: true

# OVERRIDE BULKRAX 3.0.0.beta3
module Bulkrax
  module ImporterDecorator
    # NOTE(bkiahstroud): Method to add memberships. Currently, only used by the OerCsvParser.
    def create_memberships
      parser.create_memberships if parser.respond_to?(:create_memberships)
    end
  end
end

Bulkrax::Importer.prepend(Bulkrax::ImporterDecorator)
