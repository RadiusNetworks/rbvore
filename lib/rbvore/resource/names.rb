# frozen_string_literal: true

module Rbvore
  class Resource
    module Names
      def underscore(value)
        return value unless /[A-Z-]/.match?(value)

        word = value.to_s.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

      def singularize
        @singularize ||= underscore(name.split("::").last)
      end

      def list_name
        @list_name ||= "#{singularize}_list"
      end

      def pluralize
        @pluralize ||= singularize + "s"
      end
    end
  end
end
