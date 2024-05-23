# frozen_string_literal: true

FactoryBot.define do
  factory :cdl_resource, parent: :hyku_work, class: 'CdlResource' do
  end
  factory :etd_resource, parent: :hyku_work, class: 'EtdResource' do
  end
  factory :oer_resource, parent: :hyku_work, class: 'OerResource' do
  end
end
