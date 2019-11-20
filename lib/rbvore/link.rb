# frozen_string_literal: true

module Rbvore
  class UnknownLinkError < Error; end

  class Link
    attr_accessor :href, :type

    def initialize(hash)
      self.href = hash["href"]
      self.type = hash["type"]
    end

    def type_name
      @type_name ||= type.match(/name=(?<name>[a-z\_]+)/).named_captures["name"]
    end

    def resource_class
      Rbvore.constantize(type_name)
    end

    def list?
      type_name.end_with? "list"
    end

    def api
      @api ||= API.new
    end

    def fetch(api_key: nil, params: {})
      response = api.request(
        :get,
        href,
        params: params,
        api_key: api_key,
      )
      raise response.error unless response.success?

      parse_resources(response.json_body)
    end

    def parse_resources(json_body)
      if list?
        Resource.parse_collection(json_body, resource_class)
      else
        Resource.parse_object(json_body, resource_class)
      end
    end
  end
end
