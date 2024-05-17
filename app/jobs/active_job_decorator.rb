# frozen_string_literal: true

# OVERRIDE: Include sending extra context to Raven.
module ActiveJobDecorator
  extend ActiveSupport::Concern

  class_methods do
    def deserialize(job_data)
      Raven.extra_context(job_data: job_data)
      super
    end
  end
end

ActiveJob::Base.prepend(ActiveJobDecorator)
