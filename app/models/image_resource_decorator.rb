# frozen_string_literal: true

# OVERRIDE to customize metadata
module ImageResourceDecorator
  extend ActiveSupport::Concern

  prepended do
    include Hyrax::Schema(:basic_metadata)
    include Hyrax::Schema(:bulkrax_metadata)
    include Hyrax::Schema(:image_resource_decorator)
    include Hyrax::Schema(:with_pdf_viewer)
    include Hyrax::Schema(:with_video_embed)
  end
end

ImageResource.prepend(ImageResourceDecorator)
