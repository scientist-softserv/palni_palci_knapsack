# Generated via
#  `rails generate hyrax:work Cdl`

##
# Controlled Digital Lending object.
#
# @see https://www.wikidata.org/wiki/Q61937323
class Cdl < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include IiifPrint.model_configuration(
    pdf_split_child_model: GenericWork,
    pdf_splitter_service: IiifPrint::TenantConfig::PdfSplitter
  )
  include PdfBehavior
  include VideoEmbedBehavior

  self.indexer = CdlIndexer

  before_destroy :destroy_split_pages
  after_destroy :destroy_cdl_group

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

  property :contributing_library, predicate: ::RDF::URI("https://hykucommons.org/terms/contributing_library") do |index|
    index.as :stored_searchable, :facetable
  end

  property :library_catalog_identifier, predicate: ::RDF::URI("https://hykucommons.org/terms/library_catalog_identifier") do |index|
    index.as :stored_searchable, :facetable
  end

  property :chronology_note, predicate: ::RDF::URI("https://hykucommons.org/terms/chronology_note") do |index|
    index.as :stored_searchable, :facetable
  end

  include ::Hyrax::BasicMetadata
  # This line must be kept below all others that set up properties,
  # including `include ::Hyrax::BasicMetadata`. All properties must
  # be declared before their values can be ordered.
  include OrderMetadataValues

  private

    def destroy_cdl_group
      DestroyCdlGroupJob.perform_later(id)
    end

    def destroy_split_pages
      members.each do |member|
        DestroySplitPagesJob.perform_later(member.id)
      end
    end
end
