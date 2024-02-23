# Sentry is valid in this case; as is Raven.  I'm configuring both of them
#
# The baseline sentry excluded exceptions is not the same as what all we have in Hyrax/Hyku.
# As such, we're seeing a lot of chatter in the exceptions that we probably don't need.
#
# By appending the `Rails.configuration.action_dispatch.rescue_responses.keys` we're saying that
# any "hyrax/hyku exceptions that we specifically rescue with a named response should be excluded
# from reporting to sentry."
#
# The array of strings is from Rails.configuration.action_dispatch.rescue_responses.keys

app_excluded_exceptions = ["ActiveRecord::RecordNotFound",
                           "ActiveRecord::StaleObjectError",
                           "ActiveRecord::RecordInvalid",
                           "ActiveRecord::RecordNotSaved",
                           "ActiveFedora::ObjectNotFoundError",
                           "BlacklightRangeLimit::InvalidRange",
                           "Blacklight::Exceptions::RecordNotFound",
                           "Valkyrie::Persistence::ObjectNotFoundError",
                           "Hyrax::ObjectNotFoundError",
                           "Riiif::ImageNotFoundError",
                           "I18n::InvalidLocale"]


Sentry.init do |config|
  config.excluded_exceptions = (config.excluded_exceptions + app_excluded_exceptions).uniq
end

Raven.configure do |config|
  config.excluded_exceptions = (config.excluded_exceptions + app_excluded_exceptions).uniq
end
