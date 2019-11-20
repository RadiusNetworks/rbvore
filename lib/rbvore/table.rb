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
      api.fetch_all(
        endpoint(location_id),
        Table,
        params: params,
        api_key: api_key,
      )
    end

    def self.get(location_id:, id:, params: {}, api_key: nil)
      api.fetch_one(
        endpoint(location_id, id),
        Table,
        params: params,
        api_key: api_key,
      )
    end
  end
end
