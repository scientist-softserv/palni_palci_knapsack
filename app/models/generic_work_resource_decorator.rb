# frozen_string_literal: true

# OVERRIDE to customize metadata
module GenericWorkResourceDecorator
  extend ActiveSupport::Concern

  prepended do
    include Hyrax::Schema(:basic_metadata)
    include Hyrax::Schema(:bulkrax_metadata)
    include Hyrax::Schema(:generic_work_resource_decorator)
    include Hyrax::Schema(:with_pdf_viewer)
    include Hyrax::Schema(:with_video_embed)
  end
end

GenericWorkResource.prepend(GenericWorkResourceDecorator)
