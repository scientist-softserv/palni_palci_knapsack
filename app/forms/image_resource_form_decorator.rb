# frozen_string_literal: true

module ImageResourceFormDecorator
  extend ActiveSupport::Concern

  prepended do
    include Hyrax::FormFields(:image_resource_decorator)
    include Hyrax::FormFields(:with_pdf_viewer)
    include Hyrax::FormFields(:with_video_embed)
  end
end

ImageResourceForm.prepend(ImageResourceFormDecorator)
