# frozen_string_literal: true

module AppIndexerDecorator
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc['bulkrax_identifier_tesim'] = object.bulkrax_identifier if object.respond_to?(:bulkrax_identifier)
      # TODO: Extract SortTitle to Hyku?
      solr_doc['title_ssi'] = SortTitle.new(object.title.first).alphabetical
      solr_doc['admin_note_tesim'] = object.admin_note if object.respond_to?(:admin_note)
    end
  end
end

AppIndexer.prepend(AppIndexerDecorator)
