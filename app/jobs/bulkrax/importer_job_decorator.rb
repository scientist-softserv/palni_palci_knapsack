# frozen_string_literal: true

# OVERRIDE BULKRAX 3.0.0.beta3
module Bulkrax
  module ImporterJobDecorator

    def import(importer, only_updates_since_last_import)
      importer.only_updates = only_updates_since_last_import || false
      return unless importer.valid_import?

      importer.import_objects
      # OVERRIDE BULKRAX 3.0.0.beta3 to handle custom OER relationships
      importer&.create_memberships unless importer.validate_only
    end
  end
end

Bulkrax::ImporterJob.prepend(Bulkrax::ImporterJobDecorator)