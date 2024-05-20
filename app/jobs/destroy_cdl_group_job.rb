# frozen_string_literal: true

# Probably not needed because we're only going to ever
# be destroying one group so a background job is unnecessary.
# Leaving it here for now because the Cdl model still references it.
# But in Valkyrie, we're going to just destroy the group in the Listener.
class DestroyCdlGroupJob < ApplicationJob
  queue_as :default

  def perform(id)
    Hyrax::Group.find_by(name: id)&.destroy
  end
end
