# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImageForm < Hyrax::Forms::WorkForm
    include Hyrax::FormTerms
    self.model_class = ::Image
    include PdfFormBehavior
    include VideoEmbedFormBehavior

    self.terms = [:admin_note] + self.terms # rubocop:disable Style/RedundantSelf
    self.terms += %i[resource_type extent additional_information bibliographic_citation]
    self.required_fields = %i[title creator keyword rights_statement resource_type]
  end
end
