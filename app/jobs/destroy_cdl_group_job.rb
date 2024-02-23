# frozen_string_literal: true

class DestroyCdlGroupJob < ApplicationJob
  queue_as :default

  def perform(id)
    Hyrax::Group.find_by(name: id)&.destroy
  end
end
