module Hyrax
  # Provide select options for the types field
  class ContributingLibraryService < QaSelectService
    mattr_accessor :authority
    self.authority = Qa::Authorities::Local.subauthority_for('contributing_libraries')
    def initialize(_authority_name = nil)
      super('contributing_libraries')
    end

    def self.select_options
      authority.all.map do |element|
        [element[:label], element[:id]]
      end
    end

    def self.label(id)
      authority.find(id).fetch('term')
    end
  end
end
