# frozen_string_literal: true

RSpec.describe DestroyCdlGroupJob, type: :job do
  subject(:job) { described_class.new(group.name) }

  let(:group) { FactoryBot.create(:group, name: 'test') }

  describe '#perform' do
    it 'destroys the group' do
      expect(Hyrax::Group.find_by(name: group.name)).to be_present

      job.perform(group.name)

      expect(Hyrax::Group.find_by(name: group.name)).to be_blank
    end
  end
end
