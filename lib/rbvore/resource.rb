# frozen_string_literal: true

module Rbvore
  class Resource
    extend Parsers
    include Parsers

    attr_reader :links

    def self.encode_form_data(body)
      body.map { |key, value| "#{key}=#{CGI.escape(value)}" }.join("&")
    end

    # define_link_getter sets up an attribute getter that fetches from
    # the associated link, if available
    def self.define_link_getter(name)
      define_method(name) do |opts = {}|
        stored_value = instance_variable_get("@#{name}")
        return stored_value unless stored_value.nil?

        instance_variable_set("@#{name}", fetch_link(name, api_key: opts[:api_key]))
      end
    end

    # attr_objects sets up an associated object that can be parsed from json
    def self.attr_objects(hash)
      hash.each do |name, klass|
        define_link_getter(name)
        define_method("#{name}=") do |obj|
          instance_variable_set(
            "@#{name}",
            parse_object(obj, klass),
          )
        end
      end
    end

    # attr_collections sets up an associated list of objects that can be
    # parsed from the json
    def self.attr_collections(hash)
      hash.each do |name, klass|
        define_link_getter(name)
        define_method("#{name}=") do |ary|
          instance_variable_set(
            "@#{name}",
            parse_collection(ary, klass),
          )
        end
      end
    end

    def self.attr_timestamp_accessor(*attrs)
      attrs.each do |name|
        attr_reader(name)
        define_method("#{name}=") { |value|
          instance_variable_set("@#{name}", parse_timestamp(value))
        }
      end
    end

    def set_attribute(key, value)
      setter = "#{self.class.underscore(key)}="
      send(setter, value) if respond_to?(setter)
    end

    def set_attributes(hash)
      hash.each do |key, value|
        set_attribute(key, value)
      end
      return if hash["_embedded"].nil?

      set_attributes(hash["_embedded"])
    end

    def fetch_link(name, api_key: nil, params: {})
      link = links[name.to_sym]
      raise UnknownLinkError, "Unknown link `#{name}` for #{self.class.singularize}" if link.nil?

      link.fetch(api_key: api_key, params: params)
    end

    def _links=(hash)
      @links = hash.each_with_object({}) { |(name, data), memo|
        memo[name.to_sym] = Link.new(data)
      }
    end

    def inspect
      "#<#{self.class} #{[@id, @name || @display_name].join(" ")}>"
    end

    def self.underscore(value)
      return value unless /[A-Z-]/.match?(value)

      word = value.to_s.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    def self.singularize
      @singularize ||= underscore(name.split("::").last)
    end

    def self.list_of
      @list_of ||= "#{singularize}_list"
    end

    def self.pluralize
      @pluralize ||= singularize + "s"
    end
  end
end
