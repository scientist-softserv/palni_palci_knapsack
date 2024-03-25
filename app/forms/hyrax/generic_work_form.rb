# frozen_string_literal: true

# Generated via
#  `rails generate curation_concerns:work GenericWork`
module Hyrax
  class GenericWorkForm < Hyrax::Forms::WorkForm
    include Hyrax::FormTerms
    self.model_class = ::GenericWork
    include HydraEditor::Form::Permissions
    include PdfFormBehavior
    include VideoEmbedFormBehavior

    self.terms = [:admin_note] + terms
    self.terms += %i[resource_type additional_information bibliographic_citation]
    self.required_fields = %i[title creator keyword rights_statement resource_type]
  end
end
