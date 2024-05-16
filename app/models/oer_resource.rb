# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource OerResource`
class OerResource < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
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
end
