# frozen_string_literal: true

# This is a replacement for the OpenStruct usage. The idea is to expose
# an object with a common interface.

# this file was brought over from Hyrax hyrax-v3.5.0 so that the app/models/work_view_stat_spec.rb
# and spec/models/file_download_stat_spec.rb files that were overridden have the proper context

# TODO: see whether we can make the above referenced spec files into decorators instead so that
# this file isn't necessary
class SpecStatistic
  def initialize(**kargs)
    @attributes = kargs.symbolize_keys
  end

  def [](key)
    @attributes[key.to_sym]
  end

  def method_missing(method_name, *arguments, &block)
    if @attributes.key?(method_name.to_sym)
      @attributes[method_name]
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @attributes.key?(method_name.to_sym) || super
  end
end
