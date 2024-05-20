# frozen_string_literal: true

module GenericWorkResourceFormDecorator
  extend ActiveSupport::Concern

  prepended do
    include Hyrax::FormFields(:generic_work_resource_decorator)
    include Hyrax::FormFields(:with_pdf_viewer)
    include Hyrax::FormFields(:with_video_embed)
  end
end

GenericWorkResourceForm.prepend(GenericWorkResourceFormDecorator)
