# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'
require 'order_already/spec_helper'

RSpec.describe GenericWork do
  include_examples('includes OrderMetadataValues')
  describe '#iiif_print_config#pdf_splitter_service' do
    subject { described_class.new.iiif_print_config.pdf_splitter_service }

    it { is_expected.to eq(IiifPrint::TenantConfig::PdfSplitter) }
  end

  it { is_expected.to have_already_ordered_attributes(*described_class.multi_valued_properties_for_ordering) }
end
