# frozen_string_literal: true

##
# This class is responsible for assigning a conceptually "private" group to the
# members of of the {Cdl} work.
#
# The reason for creating this group is when a person gains access to the CDL
# (via the lending application) it is more performant to add the person to a
# group than it is to add the person directly to each of the underlying files.
class CreateGroupAndAddMembersJob < ApplicationJob
  RETRY_MAX = 5

  queue_as :default

  def perform(cdl_id, retries = 0)
    work = Hyrax.query_service.find_by(id: cdl_id)
    return if work.nil?

    page_count = work.members.first.original_file.page_count.first.to_i
    child_model = work.iiif_print_config.pdf_split_child_model
    child_works_count = work.members.count { |member| member.is_a?(child_model) }

    if page_count == child_works_count
      group = Hyrax::Group.find_or_create_by!(name: work.id)
      set_acl_for_group(group, work)

      work.members.each do |member|
        assign_read_groups(group, member)
      end

      group.save
    else
      return if retries > RETRY_MAX

      retries += 1
      CreateGroupAndAddMembersJob.set(wait: 10.minutes).perform_later(cdl_id.to_s, retries)
    end
  end

  private

  def assign_read_groups(group, member)
    set_acl_for_group(group, member)
    return if member.is_a?(Hyrax::FileSet)

    member.members.each do |sub_member|
      assign_read_groups(group, sub_member)
    end
  end

  def set_acl_for_group(group, work)
    acl = Hyrax::AccessControlList.new(resource: work)
    acl.grant(:read).to(group)
    acl.save
    Hyrax.index_adapter.save(resource: work)
  end
end
