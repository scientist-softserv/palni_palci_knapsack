require 'rails_helper'

RSpec.describe OrderMetadataValues do
  let(:base_model) do
    TestWork = Struct.new(
      :prop_one_multi,
      :prop_two_singular,
      :prop_three_multi,
      :prop_four_singular
    )
  end

  before do
    # Mock the structure of a ActiveTriples::NodeConfig, which holds the
    # information for whether a property allows multiple values or not
    multiple_property_config = OpenStruct.new
    multiple_property_config.instance_variable_set(:@opts, multiple: true)
    singular_property_config = OpenStruct.new
    singular_property_config.instance_variable_set(:@opts, {})

    # Mock ActiveFedora::Base.properties for our TestWork Struct
    base_model.define_singleton_method(:properties) do
      {
        'prop_one_multi' => multiple_property_config,
        'prop_two_singular' => singular_property_config,
        'prop_three_multi' => multiple_property_config,
        'prop_four_singular' => singular_property_config
      }
    end
  end

  after do
    Object.send(:remove_const, :TestWork)
  end

  it 'defines the #multi_valued_properties_for_ordering class method' do
    expect { base_model.method(:multi_valued_properties_for_ordering) }.to raise_error(NameError)

    base_model.include(OrderMetadataValues)

    expect(base_model.method(:multi_valued_properties_for_ordering)).to be_a(Method)
  end

  it 'prepends OrderAlready for all multi-valued properties' do
    # `OrderAlready.for` initializes a new Module, which we call `prepend` on.
    # @see https://github.com/samvera-labs/order_already/blob/1a9bb51a5052257bf9870ee2892bb84b1ab72ffb/lib/order_already.rb#L45
    expect(base_model).to receive(:prepend).with(an_instance_of(Module))

    base_model.include(OrderMetadataValues)
  end

  it 'orders multi-valued properties' do
    base_model.include(OrderMetadataValues)
    work = base_model.new

    expect(work.attribute_is_ordered_already?(:prop_one_multi)).to eq(true)
    expect(work.attribute_is_ordered_already?(:prop_two_singular)).to eq(false)
    expect(work.attribute_is_ordered_already?(:prop_three_multi)).to eq(true)
    expect(work.attribute_is_ordered_already?(:prop_four_singular)).to eq(false)
  end

  describe '#multi_valued_properties_for_ordering' do
    before do
      base_model.include(OrderMetadataValues)
    end

    it 'return properties that allow multiple values' do
      expect(base_model.multi_valued_properties_for_ordering)
        .to include(:prop_one_multi, :prop_three_multi)
    end

    it 'does not return properties that only allow one value' do
      expect(base_model.multi_valued_properties_for_ordering)
        .not_to include(:prop_two_singular, :prop_four_singular)
    end
  end
end
