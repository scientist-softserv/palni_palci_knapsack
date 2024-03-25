# frozen_string_literal: true

class DestroySplitPagesJob < ApplicationJob
  queue_as :default

  def perform(id)
    work = ActiveFedora::Base.where(id: id).first
    return unless work&.is_child

    work.members.each(&:destroy)
    work.destroy
  end
end
