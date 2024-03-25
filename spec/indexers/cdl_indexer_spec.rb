# frozen_string_literal: true

RSpec.describe CdlIndexer do
  subject(:solr_document) { indexer.generate_solr_document }

  let(:indexer) { described_class.new(work) }

  describe '#generate_solr_document' do
    context 'when indexing contributing_library' do
      let(:work) { build(:cdl, contributing_library: ['US-MMET', 'US-MAWCMUM']) }

      it 'indexes the term value into contributing_library_tesim' do
        expect(solr_document['contributing_library_tesim']).to include('US-MMET', 'US-MAWCMUM')
      end

      it 'indexes the label value into contributing_library_sim' do
        expect(solr_document['contributing_library_sim']).to include('Tufts University', 'UMass Chan Medical School')
      end
    end
  end
end
