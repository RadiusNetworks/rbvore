# frozen_string_literal: true

module Rbvore
  class Table < Resource
    ENDPOINT = "/tables"

    attr_accessor :id, :available, :name, :number, :pos_id, :seats
    attr_collections open_tickets: "ticket"
    attr_objects revenue_center: "revenue_center"

    def initialize(hash)
      set_attributes(hash)
    end

    def self.api
      @api ||= API.new
    end

    def self.endpoint(location_id, id = nil)
      if id.nil?
        Location.endpoint(location_id) + ENDPOINT
      else
        Location.endpoint(location_id) + "#{ENDPOINT}/#{id}"
      end
    end

    def self.all(location_id:, params: {}, api_key: nil)
      response = api.request(
        :get,
        endpoint(location_id),
        params: params,
        api_key: api_key,
      )
      raise response.error unless response.success?

      parse_collection(response.json_body, self)
    end

    def self.get(location_id:, id:, params: {}, api_key: nil)
      response = api.request(
        :get,
        endpoint(location_id, id),
        params: params,
        api_key: api_key,
      )
      raise response.error unless response.success?

      parse_object(response.json_body, self)
    end
  end
end
