# frozen_string_literal: true

module HykuKnapsack
  module ApplicationHelper
    # OVERRIDE Hyrax::FileSetHelper#media_display_partial
    #
    # changed from hyrax 3.4.1 to change audio and video items to use default partial
    def media_display_partial(file_set)
      'hyrax/file_sets/media_display/' +
        if file_set.image?
          'image'
        elsif file_set.pdf?
          'pdf'
        elsif file_set.office_document?
          'office_document'
        else
          'default'
        end
    end
  end
end
