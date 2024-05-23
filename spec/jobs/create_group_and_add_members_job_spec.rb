# frozen_string_literal: true

RSpec.describe CreateGroupAndAddMembersJob, type: :job do
  subject(:job) { described_class.new(work.id) }

  let(:work) do
    work = FactoryBot.valkyrie_create(:cdl_resource, title: ['Test CDL'])
    work.member_ids << file_set.id
    Hyrax.persister.save(resource: work)
  end
  let(:split_work_factory) { work.iiif_print_config.pdf_split_child_model.to_s.underscore }
  let(:work_original_file) { FactoryBot.valkyrie_create(:hyrax_file_metadata, use: :original_file, page_count: ["2"]) }
  let(:file_set) { FactoryBot.valkyrie_create(:hyrax_file_set, title: ['Test File Set'], files: [work_original_file]) }
  let(:work_page_1) { FactoryBot.valkyrie_create(split_work_factory, title: ["#{work.id} - #{work.title.first} Page 1"]) }
  let(:work_page_2) { FactoryBot.valkyrie_create(split_work_factory, title: ["#{work.id} - #{work.title.first} Page 2"]) }
  let(:file_set_page_1) { FactoryBot.valkyrie_create(:hyrax_file_set, title: ["page1.jpg"]) }
  let(:file_set_page_2) { FactoryBot.valkyrie_create(:hyrax_file_set, title: ["page2.jpg"]) }

  # before { allow_any_instance_of(FileSet).to receive(:page_count).and_return(["2"]) }

  describe '#perform' do
    context 'when has all its child works' do
      before do
        work.member_ids << work_page_1.id
        work.member_ids << work_page_2.id
        Hyrax.persister.save(resource: work)
        work_page_1.member_ids << file_set_page_1.id
        Hyrax.persister.save(resource: work_page_1)
        work_page_2.member_ids << file_set_page_2.id
        Hyrax.persister.save(resource: work_page_2)
      end

      it 'creates a group' do
        expect { job.perform(work.id) }.to change { Hyrax::Group.count }.by(1)
      end

      it 'assigns the group to the work read_groups' do
        job.perform(work.id)

        expect(Hyrax.query_service.find_by(id: work.id).read_groups.to_a).to eq([work.id.to_s])
      end

      it "assigns the group to the read_groups of each work's member" do
        job.perform(work.id)

        expect(Hyrax.query_service.find_by(id: work_page_1.id).read_groups.to_a).to eq([work.id.to_s])
        expect(Hyrax.query_service.find_by(id: work_page_2.id).read_groups.to_a).to eq([work.id.to_s])
      end

      it "assigns the group to the read_groups of each work's member's member" do
        job.perform(work.id)

        expect(Hyrax.query_service.find_by(id: file_set_page_1.id).read_groups.to_a).to eq([work.id.to_s])
        expect(Hyrax.query_service.find_by(id: file_set_page_2.id).read_groups.to_a).to eq([work.id.to_s])
      end
    end

    context 'when does not have all its child works' do
      before do
        work.member_ids << work_page_1.id
        Hyrax.persister.save(resource: work)
      end

      it 'retries the job' do
        expect(described_class).to receive(:set).with(wait: 10.minutes).and_return(described_class)

        job.perform(work.id)
      end

      it 'does not retry the job more than 5 times' do
        expect(described_class).not_to receive(:set)

        job.perform(work.id, 6)
      end
    end
  end
end
