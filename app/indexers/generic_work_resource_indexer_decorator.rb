# frozen_string_literal: true

module GenericWorkResourceIndexerDecorator
  extend ActiveSupport::Concern

  prepended do
    include Hyrax::Indexer(:generic_work_resource_decorator)
    include Hyrax::Indexer(:with_pdf_viewer)
    include Hyrax::Indexer(:with_video_embed)
  end
end

GenericWorkResourceIndexer.prepend(GenericWorkResourceIndexerDecorator)
