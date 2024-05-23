# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FileSet do
  describe "metadata" do
    it { is_expected.to have_property(:bulkrax_identifier).with_predicate("https://hykucommons.org/terms/bulkrax_identifier") }
  end
end
