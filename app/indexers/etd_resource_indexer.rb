# frozen_string_literal: true


# TODO: temporarily added to see if iiif print engine spec error would resolve. (it did)
# so some of the spec failures is because the models haven't been
# valkyrized

# Generated via
#  `rails generate hyrax:work_resource GenericWorkResource`
class EtdResourceIndexer < Hyrax::ValkyrieWorkIndexer
  # TODO: specify custom properties for this work type

  # include Hyrax::Indexer(:basic_metadata)
  # include Hyrax::Indexer(:bulkrax_metadata)
  # include Hyrax::Indexer(:generic_work_resource)
  # include Hyrax::Indexer(:with_pdf_viewer)
  # include Hyrax::Indexer(:with_video_embed)

  include HykuIndexing
  # Uncomment this block if you want to add custom indexing behavior:
  #  def to_solr
  #    super.tap do |index_document|
  #      index_document[:my_field_tesim]   = resource.my_field.map(&:to_s)
  #      index_document[:other_field_ssim] = resource.other_field
  #    end
  #  end
end