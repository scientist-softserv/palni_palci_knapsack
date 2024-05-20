# frozen_string_literal: true

module Listeners
  class CdlListener
    def on_object_deleted(event)
      object = event[:object]
      return unless object.is_a?(CdlResource)

      id = object.id
      Hyrax::Group.find_by(name: id)&.destroy
    end
  end
end
