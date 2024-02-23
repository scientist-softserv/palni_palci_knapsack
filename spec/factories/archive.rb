FactoryBot.define do
  factory :archive do
    transient do
      user { FactoryBot.create(:user) }
    end

    title { ["title"] }
    is_restricted { "1" }
    is_homepage { "0" }
    publisher_name { "Publisher name" }
    publisher_url { "http://publisherurl.com" }
    publish_country { "Publish country" }
    publish_location { "Publish location" }
    external_url { "http://externalurl.com" }
    date_published { "2020-03-03" }
    copyright_owner_name { "Copyright owner name" }
    copyright_owner_url { "http://copyrightownerurl.com" }
    source_credit { "Source credit" }
    archive_page_count { "10" }
    series_title { "1" }
    volume_number { "1" }
    isbn_10 { "ISBN 10" }
    isbn_13 { "ISBN 13" }
    oclc { "oclc" }
    lccn { "lccn" }

    factory :archive_with_one_file do
      before(:create) do |work, evaluator|
        work.ordered_members << FactoryBot.create(:file_set,
                                                  user: evaluator.user,
                                                  title: ['A Sample Book with file'])
      end
    end

    factory :archive_with_file_and_work do
      before(:create) do |work, evaluator|
        work.ordered_members << create(:file_set, user: evaluator.user)
        work.ordered_members << create(:book, user: evaluator.user)
      end
    end

    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user)
    end
  end
end