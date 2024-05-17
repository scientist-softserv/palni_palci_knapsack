# frozen_string_literal: true

module SolrDocumentDecorator
  extend ActiveSupport::Concern

  def show_pdf_viewer
    self['show_pdf_viewer_tesim']
  end

  def show_pdf_download_button
    self['show_pdf_download_button_tesim']
  end

end

SolrDocument.include(SolrDocumentDecorator)