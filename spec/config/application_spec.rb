# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hyku::Application do
  describe ".cross_tenant_search_url" do
    subject { described_class.cross_tenant_search_url }

    it { is_expected.to start_with("//") }
  end

  describe ".cross_tenant_search_host" do
    subject { described_class.cross_tenant_search_host }

    it { is_expected.to be_present }
    it { is_expected.to be_a(String) }
  end
end
