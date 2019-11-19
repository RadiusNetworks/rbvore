# frozen_string_literal: true

module Rbvore
  class Resource # rubocop:disable Metrics/ClassLength
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
            self.class.parse_object(obj, self.class.klass_for(klass)),
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
            self.class.parse_collection(ary, self.class.klass_for(klass)),
          )
        end
      end
    end

    def self.attr_timestamp_accessor(*attrs)
      attrs.each do |name|
        attr_reader(name)
        define_method("#{name}=") { |value|
          instance_variable_set("@#{name}", self.class.parse_date(value))
        }
      end
    end

    def set_attribute(key, value)
      setter = "#{self.class.underscore(key)}="
      send(setter, value) if respond_to?(setter)
    end

    def set_attributes(hash) # rubocop:disable Naming/AccessorMethodName
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

    def self.parse_collection(ary, klass)
      if ary.is_a? Hash
        list = ary.dig("_embedded", klass.pluralize)
        ary = list if list.is_a? Array
      end
      ary.map { |obj|
        parse_object(obj, klass)
      }
    end

    def self.parse_object(obj, klass)
      if obj.is_a?(Hash)
        klass.new(obj)
      else
        obj
      end
    end

    def self.parse_date(value)
      return nil if value.nil?

      if value.is_a? Time
        value
      else
        Time.at(value)
      end
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

    def self.resource_subclass?(klass)
      klass.respond_to?(:superclass) && klass.superclass == Resource
    end

    def self.klasses
      @klasses ||= Rbvore.constants.map { |const|
        klass = Rbvore.const_get(const)
        klass if resource_subclass?(klass)
      }.compact
    end

    def self.klass_for(name)
      return name if resource_subclass?(name)

      klasses.each do |klass|
        return klass if [klass.singularize, klass.list_of, klass.pluralize].include?(name)
      end
      return nil
    end
  end
end
