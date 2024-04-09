# frozen_string_literal: true

# OVERRIDE Add SuperAdmin Settings for
class AccountDecorator
  extend ActiveSupport::Concern

  SUPERADMIN_SETTINGS = [:analytics_provider, :contact_email, :file_acl,
                         :file_size_limit, :oai_prefix,
                         :oai_sample_identifier, :s3_bucket].freeze

  class_methods do
    def superadmin_settings
      AccountDecorator::SUPERADMIN_SETTINGS
    end
  end
end

Account.prepend(AccountDecorator)

# TODO: Does redeclaring this work?  We'll want to write a test for this.
Account.setting :contact_email, type: 'string', default: 'consortial-ir@palci.org'
Account.setting :contact_email_to, type: 'string', default: 'consortial-ir@palci.org'
