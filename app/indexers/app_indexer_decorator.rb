# frozen_string_literal: true

module AppIndexerDecorator
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc['admin_note_tesim'] = object.admin_note if object.respond_to?(:admin_note)
    end
  end
end

AppIndexer.prepend(AppIndexerDecorator)
