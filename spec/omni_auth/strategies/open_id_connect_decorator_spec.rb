# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/MultipleDescribes
RSpec.describe OmniAuth::Strategies::OpenIDConnectDecorator do
  let(:strategy) do
    Class.new do
      def initialize(options: {}, session: {}, request:, env: {})
        @options = options
        @session = session
        @request = request
        @env = env
      end
      attr_reader :options, :session, :request, :env

      delegate :params, to: :request

      # Include this after the attr_reader :options to leverage super method
      prepend OmniAuth::Strategies::OpenIDConnectDecorator
    end
  end

  let(:requested_work_url) { "http://pals.hyku.test/concern/generic_works/f2af2a68-7c79-481b-815e-a91517e23761?locale=en" }
  # rubocop:disable Metrics/LineLength
  let(:uv_url) { "https://pals.hyku.test/uv/uv.html#?manifest=http://pals.hyku.test/concern/generic_works/f2af2a68-7c79-481b-815e-a91517e23761/manifest&config=https://pals.hyku.test/uv/uv-config-reshare.json" }
  # rubocop:enable Metrics/LineLength
  let(:options) { { scope: [:openid] } }
  let(:session) { {} }
  let(:request) { double(ActionDispatch::Request, params: params) }
  let(:params) { {} }
  let(:cookie_jar) { {} }
  let(:instance) { strategy.new(options: options, session: session, request: request) }

  before do
    allow_any_instance_of(ActionDispatch::Request).to receive(:cookie_jar).and_return(cookie_jar)
    allow_any_instance_of(ActionDispatch::Request).to receive(:host_with_port).and_return("pals.hyku.test")
  end

  describe '#options' do
    subject { instance.options }

    let(:cookie_jar) { { reshare_url: requested_work_url } }

    it "has a :scope key that appends the #requested_work_url" do
      expect(subject.fetch(:scope)).to match_array([:openid, requested_work_url])
    end
  end

  describe '#requested_work_url' do
    subject { instance.requested_work_url }

    describe "when the cookie_jar has reshare_url" do
      let(:cookie_jar) { { reshare_url: requested_work_url } }

      it "uses the URL in the cookie jar" do
        expect(subject).to eq(requested_work_url)
      end
    end

    describe "when the 'cdl.requested_work_url' key is missing" do
      context "when request does not include scope" do
        it { is_expected.to be_nil }
      end

      context "when request includes a scope" do
        let(:params) { { 'scope' => requested_work_url } }

        it "uses the scope to derive the requested work url" do
          expect(subject).to eq(uv_url)
        end
      end
    end
  end
end

RSpec.describe OmniAuth::Strategies::OpenIDConnect do
  describe '#options method' do
    subject(:options_method) { described_class.instance_method(:options) }

    context 'source_location' do
      subject { options_method.source_location }

      it { is_expected.to match_array([Rails.root.join('lib', 'omni_auth', 'strategies', 'open_id_connect_decorator.rb').to_s, Integer]) }
    end

    context 'super_method' do
      subject { options_method.super_method }

      it { is_expected.not_to be_nil }
    end
  end
end
# rubocop:enable RSpec/MultipleDescribes
