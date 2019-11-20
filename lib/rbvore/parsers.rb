# frozen_string_literal: true

module Rbvore
  module Parsers
    def parse_collection(ary, klass)
      if ary.is_a? Hash
        list = ary.dig("_embedded", klass.pluralize)
        ary = list if list.is_a? Array
      end
      ary.map { |obj|
        parse_object(obj, klass)
      }
    end

    def parse_object(obj, klass)
      if obj.is_a?(Hash)
        Rbvore.constantize(klass).new(obj)
      else
        obj
      end
    end

    def parse_timestamp(value)
      return nil if value.nil?

      if value.is_a? Time
        value
      else
        Time.at(value)
      end
    end
  end
end
