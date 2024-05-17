# frozen_string_literal: true

RSpec.describe DestroySplitPagesJob, type: :job do
  subject(:job) { described_class.new(work_page_1.id) }

  let(:work_page_1) { FactoryBot.create(:generic_work, title: ["Page 1"], is_child: true) }
  let(:file_set) { FactoryBot.create(:file_set, title: ["page1.jpg"]) }

  before do
    work_page_1.ordered_members << file_set
    work_page_1.save
  end

  describe '#perform' do
    it 'destroys the child works when the work is destroyed' do
      expect { work_page_1.class.find(work_page_1.id) }.not_to raise_error
      expect { FileSet.find(file_set.id) }.not_to raise_error

      job.perform(work_page_1.id)

      expect { work_page_1.class.find(work_page_1.id) }.to raise_error(Ldp::Gone)
      expect { FileSet.find(file_set.id) }.to raise_error(Ldp::Gone)
    end
  end
end
