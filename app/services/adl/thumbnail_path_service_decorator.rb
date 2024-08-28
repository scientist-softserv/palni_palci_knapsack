# frozen_string_literal: true

# OVERRIDE Hyrax v5.0.0rc2 + Hyku v6.0 - to set custom collection thumbnail default

module Adl
  module ThumbnailPathServiceDecorator
    def default_collection_image
      Site.instance.default_collection_image&.url || ActionController::Base.helpers.image_path('default-collection.png')
    end
  end
end

Hyrax::ThumbnailPathServiceDecorator.prepend( Adl::ThumbnailPathServiceDecorator)
