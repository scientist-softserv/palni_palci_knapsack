# frozen_string_literal: true

module ImageResourceIndexerDecorator
  extend ActiveSupport::Concern

  prepended do
    include Hyrax::Indexer(:image_resource_decorator)
    include Hyrax::Indexer(:with_pdf_viewer)
    include Hyrax::Indexer(:with_video_embed)
  end
end

ImageResourceIndexer.prepend(ImageResourceIndexerDecorator)
