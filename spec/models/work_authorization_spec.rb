# frozen_string_literal: true
require 'spec_helper'

require 'cancan/matchers'

RSpec.describe WorkAuthorization, type: :model do
  let(:work) { FactoryBot.valkyrie_create(:generic_work_resource, title: ['Work Title']) }
  let(:other_work) { FactoryBot.valkyrie_create(:generic_work_resource, title: ['Other Work']) }
  let(:borrowing_user) { FactoryBot.create(:user) }
  let(:ability) { ::Ability.new(borrowing_user) }
  let(:group) { FactoryBot.create(:group, name: work.id) }
  let(:other_group) { FactoryBot.create(:group, name: other_work.id) }

  before do
    acl = Hyrax::AccessControlList.new(resource: work)
    acl.grant(:read).to(group)
    acl.save
    other_acl = Hyrax::AccessControlList.new(resource: other_work)
    other_acl.grant(:read).to(other_group)
    other_acl.save
  end

  describe '.extract_pids_from' do
    subject { described_class.extract_pids_from(scope: given_test_scope) }

    [
      ["http://pals.hyku.test/concern/generic_works/f2af2a68-7c79-481b-815e-a91517e23761?locale=en openid", ["f2af2a68-7c79-481b-815e-a91517e23761"]],
      ["openid", []],
      ["http://pals.hyku.test/concern/generic_works/f2af2a68-7c79-481b-815e-a91517e23761?locale=en", ["f2af2a68-7c79-481b-815e-a91517e23761"]],
      ["http://pals.hyku.test/collection/f2af2a68-7c79-481b-815e-a91517e23761?locale=en", []],
      [nil, []]
    ].each do |given_scope, expected_value|
      context "with #{given_scope.inspect}" do
        let(:given_test_scope) { given_scope }

        it { is_expected.to match_array(expected_value) }
      end
    end
  end

  # rubocop:disable Metrics/LineLength
  describe '.url_from' do
    subject { described_class.url_from(scope: given_test_scope, request:) }

    let(:request) { double(ActionDispatch::Request, env: { 'rack.url_scheme' => "http" }, host_with_port: "pals.hyku.test") }

    [
      ["http://pals.hyku.test/concern/generic_works/f2af2a68-7c79-481b-815e-a91517e23761?locale=en openid", "http://pals.hyku.test/uv/uv.html#?manifest=http://pals.hyku.test/concern/generic_works/f2af2a68-7c79-481b-815e-a91517e23761/manifest&config=http://pals.hyku.test/uv/uv-config-reshare.json"],
      ["/concern/generic_works/f2af2a68-7c79-481b-815e-a91517e23761?locale=en openid", "http://pals.hyku.test/uv/uv.html#?manifest=/concern/generic_works/f2af2a68-7c79-481b-815e-a91517e23761/manifest&config=http://pals.hyku.test/uv/uv-config-reshare.json"],
      ["/help/me/123 openid", nil],
      [nil, nil]
    ].each do |given_scope, expected_value|
      context "with #{given_scope.inspect}" do
        let(:given_test_scope) { given_scope }

        it { is_expected.to eq(expected_value) }
      end
    end
  end
  # rubocop:enable Metrics/LineLength

  describe '.handle_signin_for!' do
    context 'when given a work_pid and a scope' do
      it 'will authorize the given work_pid and scope’s work' do
        given_scope = "http://pals.hyku.test/concern/generic_works/#{other_work.id}?locale=en openid"

        expect(Ability.new(borrowing_user).can?(:read, work.id)).to be_falsey
        expect(Ability.new(borrowing_user).can?(:read, other_work.id)).to be_falsey

        described_class.handle_signin_for!(user: borrowing_user, work_pid: work.id, scope: given_scope, authorize_until: 1.day.from_now)

        expect(Ability.new(borrowing_user).can?(:read, Hyrax.query_service.find_by(id: work.id))).to be_truthy
        expect(Ability.new(borrowing_user).can?(:read, Hyrax.query_service.find_by(id: other_work.id))).to be_truthy
      end
    end

    context 'when given a work_pid' do
      it 'will re-authorize the given work and expire non-specified works' do
        described_class.authorize!(user: borrowing_user, work:, group:, expires_at: 1.day.ago)
        described_class.authorize!(user: borrowing_user, work: other_work, group: other_group, expires_at: 1.day.ago)

        expect(Ability.new(borrowing_user).can?(:read, work)).to be_truthy
        expect(Ability.new(borrowing_user).can?(:read, other_work)).to be_truthy

        described_class.handle_signin_for!(user: borrowing_user, work_pid: work.id, authorize_until: 1.day.from_now)

        expect(Ability.new(borrowing_user).can?(:read, Hyrax.query_service.find_by(id: work.id))).to be_truthy
        expect(Ability.new(borrowing_user).can?(:read, Hyrax.query_service.find_by(id: other_work.id))).to be_falsey
      end
    end

    context 'when not given a work_pid' do
      it 'will de-authorize all authorizations that have expired but not those that have not expired' do
        # NOTE: This one is expiring in the future
        described_class.authorize!(user: borrowing_user, work:, group:, expires_at: 2.days.from_now)
        # NOTE: We'll be expiring this one.
        described_class.authorize!(user: borrowing_user, work: other_work, group: other_group, expires_at: 1.day.ago)

        expect(Ability.new(borrowing_user).can?(:read, work)).to be_truthy
        expect(Ability.new(borrowing_user).can?(:read, other_work)).to be_truthy

        described_class.handle_signin_for!(user: borrowing_user, revoke_expirations_before: Time.zone.now)

        expect(Ability.new(borrowing_user).can?(:read, work)).to be_truthy
        expect(Ability.new(borrowing_user).can?(:read, other_work)).to be_falsey
      end
    end
  end

  describe '.authorize!' do
    it 'gives the borrowing user the ability to "read" the work' do
      # # We re-instantiate an ability class because CanCan caches many of the ability checks.  By
      # # both passing the id and reinstantiating, we ensure that we have the most fresh data; that is
      # # no cached ability "table" nor cached values on the work.
      # expect { described_class.authorize!(user: borrowing_user, work: Hyrax.query_service.find_by(id: work.id), group: group) }
      #   .to change { ::Ability.new(borrowing_user).can?(:read, work.id) }.from(false).to(true)
      expect(Ability.new(borrowing_user).can?(:read, work)).to be_falsey
      described_class.authorize!(user: borrowing_user, work: Hyrax.query_service.find_by(id: work.id), group:)
      expect(Ability.new(borrowing_user).can?(:read, work)).to be_truthy
    end
  end

  describe '.revoke!' do
    it 'revokes an authorized user from being able to "read" the work' do
      # Ensuring we're authorized
      described_class.authorize!(user: borrowing_user, work:, group:)

      expect { described_class.revoke!(user: borrowing_user, work:) }
        .to change { ::Ability.new(borrowing_user).can?(:read, work) }.from(true).to(false)
    end

    it 'gracefully handles revoking that which was never authorized' do
      expect { described_class.revoke!(user: borrowing_user, work:) }
        .not_to change { ::Ability.new(borrowing_user).can?(:read, work) }.from(false)
    end
  end

  xdescribe 'adding errors' do
    let(:authorization) { WorkAuthorization.new }

    it 'adds the error' do
      authorization.update_error 'test error'
      expect(authorization.error).to eq('test error')
    end

    it 'clears error' do
      authorization.update_error 'test error'
      authorization.clear_error
      expect(authorization.error).to eq(nil)
    end
  end
end
