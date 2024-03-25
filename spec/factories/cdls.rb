# frozen_string_literal: true

FactoryBot.define do
  factory :cdl, aliases: [:cdl_work] do
    transient do
      user { FactoryBot.create(:user) }
    end

    title { ["Test title"] }

    factory :public_cdl, aliases: [:public_cdl_work], traits: [:public]

    trait :public do
      visibility { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    end

    identifier do
      %w[
        ISBN:978-83-7659-303-6 978-3-540-49698-4 9790879392788
        doi:10.1038/nphys1170 3-921099-34-X 3-540-49698-x 0-19-852663-6
      ]
    end

    factory :cdl_work_with_one_file do
      before(:create) do |work, evaluator|
        work.ordered_members << FactoryBot.create(:file_set,
                                                  user: evaluator.user,
                                                  title: ['A Contained Cdl File'])
      end
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user)
    end
  end
end
