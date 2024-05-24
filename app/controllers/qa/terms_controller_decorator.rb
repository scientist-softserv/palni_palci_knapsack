# frozen_string_literal: true

module Qa
  module TermsControllerDecorator
    def search
      private

      permitted_params
    end
  end
end

Qa::TermsController.prepend(Qa::TermsControllerDecorator)
