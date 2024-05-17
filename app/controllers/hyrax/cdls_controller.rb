# Generated via
#  `rails generate hyrax:work Cdl`
module Hyrax
  # Generated controller for Cdl
  class CdlsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Cdl

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::CdlPresenter
  end
end
