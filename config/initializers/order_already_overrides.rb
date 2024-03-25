# frozen_string_literal: true

# OVERRIDE: OrderAlready 0.3.1 This file contains nil check overrides
# https://github.com/samvera-labs/order_already/issues/1

OrderAlready::InputOrderSerializer.module_eval do
  TOKEN_DELIMITER = '~'
  # OVERRIDE: OrderAlready 0.3.1 add check for arr.nil?
  def self.serialize(arr)
    return [] if arr.nil?
    return [] if arr&.empty?
    arr = arr.compact
    arr = sanitize(arr)

    res = []
    arr.each_with_index do |val, ix|
      res << encode(ix, val)
    end

    res
  end

  def self.sanitize(values)
    full_sanitizer = Rails::Html::FullSanitizer.new
    # OVERRIDE: OrderAlready 0.3.1 add check for values.nil?
    unless values.nil?
      sanitized_values = Array.new(values.size, '')
      empty = TOKEN_DELIMITER * 3
      values.each_with_index do |v, i|
        sanitized_values[i] = full_sanitizer.sanitize(v) unless v == empty
      end
    end
  end
end