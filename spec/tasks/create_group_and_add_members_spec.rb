# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'hyku:cdl:create_group_and_add_members' do
  before do
    Rake.application.rake_require "tasks/create_group_and_add_members"
    Rake::Task.define_task(:environment)
  end

  let :run_rake_task do
    Rake::Task["hyku:cdl:create_group_and_add_members"].reenable
    Rake::Task["hyku:cdl:create_group_and_add_members"].invoke('id1.id2.id3')
  end

  it "invoke CreateGroupAndAddMembersJob" do
    expect(CreateGroupAndAddMembersJob).to receive(:perform_later).exactly(3).times
    run_rake_task
  end
end
