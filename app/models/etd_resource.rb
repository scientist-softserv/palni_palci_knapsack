# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource EtdResource`
class EtdResource < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:etd_resource)
end
