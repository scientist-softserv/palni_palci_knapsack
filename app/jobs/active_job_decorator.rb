# frozen_string_literal: true

# OVERRIDE: Include sending extra context to Sentry.
module ActiveJobDecorator
  extend ActiveSupport::Concern

  class_methods do
    def deserialize(job_data)
      Sentry.set_extras(job_data:)
      super
    end
  end
end

ActiveJob::Base.prepend(ActiveJobDecorator)
