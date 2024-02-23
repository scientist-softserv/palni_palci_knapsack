# Generated via
#  `rails generate hyrax:work Cdl`
require 'rails_helper'
require 'order_already/spec_helper'

RSpec.describe Cdl do
  include_examples('includes OrderMetadataValues')
  describe '#iiif_print_config#pdf_splitter_service' do
    subject { described_class.new.iiif_print_config.pdf_splitter_service }

    it { is_expected.to eq(IiifPrint::TenantConfig::PdfSplitter) }
  end

  describe "metadata" do
    it { is_expected.to have_property(:bulkrax_identifier).with_predicate("https://hykucommons.org/terms/bulkrax_identifier") }
  end

  it { is_expected.to have_already_ordered_attributes(*described_class.multi_valued_properties_for_ordering) }
end
