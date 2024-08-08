# frozen_string_literal: true

IiifPrint.config do |config|
  # NOTE: WorkTypes and models are used synonymously here.
  # Add models to be excluded from search so the user
  # would not see them in the search results.
  # by default, use the human-readable versions like:
  # @example
  #   config.excluded_model_name_solr_field_values = ['Generic Work', 'Image']

  # Add configurable Solr field key for searching,
  # default key is: 'human_readable_type_sim'
  # if another key is used, make sure to adjust the
  # config.excluded_model_name_solr_field_values to match
  # @example
  #   config.excluded_model_name_solr_field_key = 'some_solr_field_key'

  # Configure how the manifest sorts the canvases, by default it sorts by :title,
  # but a different model property may be desired such as :date_published
  # @example
  #   config.sort_iiif_manifest_canvases_by = :date_published

  # config.default_iiif_manifest_version = 3

  config.child_work_attributes_function = lambda do |parent_work:, admin_set_id:|
    embargo = parent_work.embargo
    lease = parent_work.lease
    embargo_params = {}
    lease_params = {}
    visibility_params = {}

    if embargo
      embargo_params = {
        visibility: 'embargo',
        visibility_after_embargo: embargo.visibility_after_embargo,
        visibility_during_embargo: embargo.visibility_during_embargo,
        embargo_release_date: embargo.embargo_release_date
      }
    elsif lease
      lease_params = {
        visibility: 'lease',
        visibility_after_lease: lease.visibility_after_lease,
        visibility_during_lease: lease.visibility_during_lease,
        lease_release_date: lease.lease_expiration_date
      }
    else
      visibility_params = { visibility: parent_work.visibility.to_s }
    end

    params = {
      admin_set_id: admin_set_id.to_s,
      creator: parent_work.creator.to_a,
      keyword: parent_work.keyword,
      rights_statement: parent_work.rights_statement.to_a,
      is_child: true
    }

    params.merge!(embargo_params).merge!(lease_params).merge!(visibility_params)
  end
end
