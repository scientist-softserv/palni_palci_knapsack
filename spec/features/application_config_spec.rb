# frozen_string_literal: true

require 'spec_helper'

RSpec.describe "Application Configuration" do
  describe 'ApplicationController#view_paths' do
    subject(:view_paths) { ApplicationController.view_paths.map(&:to_s) }

    it { is_expected.to be_a Array }

    describe 'first element' do
      subject { view_paths.first }

      it { is_expected.to eq(Rails.root.join("app", "views").to_s) }
    end
  end
end
