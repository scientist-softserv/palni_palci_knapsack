# frozen_string_literal: true

# These methods override 2.5.1 behavior defined in hyrax_helper_behavior.rb
module Hyrax
  module OverrideHelperBehavior
    # @param values [Array{String}] strings to display
    # @param solr_field [String] name of the solr field to link to, without its suffix (:facetable)
    # @param empty_message [String] message to display if no values are passed in
    # @param separator [String] value to join with
    # @return [ActiveSupport::SafeBuffer] the html_safe link
    def link_to_facet_list(values, solr_field, empty_message = "No value entered", separator = ", ")
      return empty_message if values.blank?
      facet_field = "#{solr_field}_sim"
      safe_join(values.map { |item| link_to_facet(item, facet_field) }, separator)
    end

    # Used by the gallery view
    def collection_thumbnail(_document, _image_options = {}, _url_options = {})
      return super if Site.instance.default_collection_image.blank?

      image_tag(Site.instance.default_collection_image&.url)
    end

    def collection_title_by_id(id)
      solr_docs = controller.repository.find(id).docs
      return nil if solr_docs.empty?
      solr_field = solr_docs.first["title_tesim"]
      return nil if solr_field.nil?
      solr_field.first
    end

    # @param [ActionController::Parameters] params first argument for Blacklight::SearchState.new
    # @param [Hash] facet
    # @note Ignores all but the first facet.  Probably a bug.
    def search_state_with_facets(params, facet = {})
      state = Blacklight::SearchState.new(params, CatalogController.blacklight_config)
      return state.params if facet.none?
      state.add_facet_params("#{facet.keys.first}_sim",
                             facet.values.first)
    end

    def truncate_and_iconify_auto_link(field, show_link = true)
      if field.is_a? Hash
        options = field[:config].separator_options || {}
        text = field[:value].to_sentence(options)
      else
        text = field
      end
      # this block is only executed when a link is inserted;
      # if we pass text containing no links, it just returns text.
      auto_link(html_escape(text)) do |value|
        "<span class='fa fa-external-link'></span>#{('&nbsp;' + value) if show_link}"
      end
      text.truncate(230, separator: ' ')
    end
  end
end
