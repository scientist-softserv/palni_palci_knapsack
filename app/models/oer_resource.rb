# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource OerResource`
class OerResource < Hyrax::Work
  # Commented out basic_metadata because these terms were added to etd_resource so we can customize it.
  # include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:oer_resource)
  include Hyrax::Schema(:with_pdf_viewer)
  include Hyrax::Schema(:with_video_embed)
  include Hyrax::ArResource
  include Hyrax::NestedWorks

  Hyrax::ValkyrieLazyMigration.migrating(self, from: Oer)

  include IiifPrint.model_configuration(
    pdf_split_child_model: GenericWorkResource,
    pdf_splitter_service: IiifPrint::TenantConfig::PdfSplitter
  )

  prepend OrderAlready.for(:creator)

  def previous_version
    @previous_version ||= Hyrax.query_service.find_by(id: previous_version_id) if previous_version_id
  end

  def newer_version
    @newer_version ||= Hyrax.query_service.find_by(id: newer_version_id) if newer_version_id
  end

  def alternate_version
    @alternate_version ||= Hyrax.query_service.find_by(id: alternate_version_id) if alternate_version_id
  end

  def related_item
    @related_item ||= Hyrax.query_service.find_by(id: related_item_id) if related_item_id
  end
end
