# Generated via
#  `rails generate hyrax:work Cdl`
module Hyrax
  class CdlPresenter < Hyku::WorkShowPresenter
    delegate :abstract,
             :contributing_library,
             :library_catalog_identifier,
             :chronology_note,
             to: :solr_document

    def human_readable_type
      Cdl.model_name.i18n_key.upcase
    end
  end
end
