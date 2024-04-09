# frozen_string_literal: true

# OVERRIDE: Hyrax 5.0.1 to handed is_derived
class AttachFilesToWorkJobDecorator
  def attach_work(user, work, work_attributes, work_permissions, uploaded_file)
    actor = Hyrax::Actors::FileSetActor.new(FileSet.create, user)
    file_set_attributes = file_set_attrs(work_attributes, uploaded_file)
    metadata = visibility_attributes(work_attributes, file_set_attributes)
    # BEGIN OVERRIDE v5.0.1
    metadata[:is_derived] = uploaded_file.derived?
    # END OVERRIDE v5.0.1
    uploaded_file.add_file_set!(actor.file_set)
    actor.file_set.permissions_attributes = work_permissions
    actor.create_metadata(metadata)
    actor.create_content(uploaded_file)
    actor.attach_to_work(work, metadata)
  end
end
