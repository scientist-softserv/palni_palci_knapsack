# frozen_string_literal: true

class GenericWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include IiifPrint.model_configuration(
    pdf_split_child_model: self,
    pdf_splitter_service: IiifPrint::TenantConfig::PdfSplitter
  )
  include PdfBehavior
  include VideoEmbedBehavior

  self.indexer = GenericWorkIndexer

  validates :title, presence: { message: 'Your work must have a title.' }

  property :additional_information, predicate: ::RDF::Vocab::DC.accessRights do |index|
    index.as :stored_searchable
  end

  property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation do |index|
    index.as :stored_searchable
  end

  property :bulkrax_identifier, predicate: ::RDF::URI("https://hykucommons.org/terms/bulkrax_identifier"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :admin_note, predicate: ::RDF::Vocab::SCHEMA.positiveNotes, multiple: false do |index|
    index.as :stored_searchable
  end

  property :date, predicate: ::RDF::URI("https://hykucommons.org/terms/date"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  include ::Hyrax::BasicMetadata
  # This line must be kept below all others that set up properties,
  # including `include ::Hyrax::BasicMetadata`. All properties must
  # be declared before their values can be ordered.
  include OrderMetadataValues
  self.indexer = GenericWorkIndexer
end
