# frozen_string_literal: true

module Bulkrax
  class RelatedMemberObjectFactory < ObjectFactory
    # TODO: We handle this for the new ValkyrieObjectFactory
    def permitted_attributes
      %i[related_members_attributes] + super
    end
  end
end
