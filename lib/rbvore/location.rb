# frozen_string_literal: true

module Rbvore
  class Location < Resource
    ENDPOINT = "/1.0/locations"

    attr_accessor :address, :concept_name, :display_name, :name, :id, :custom_id,
                  :google_place_id, :health, :latitude, :longitude, :owner, :phone,
                  :pos_type, :status, :timezone, :website

    attr_collections(
      tender_types: TenderType,
      employees: Employee,
      tables: Table,
      order_types: OrderType,
      revenue_centers: RevenueCenter,
      tickets: Ticket,
    )

    def self.api
      @api ||= API.new
    end

    def self.endpoint(location_id)
      "#{ENDPOINT}/#{location_id}"
    end

    def self.all(api_key: nil)
      response = api.request(
        :get,
        ENDPOINT,
        api_key: api_key,
      )
      raise response.error unless response.success?

      response.json_body["_embedded"]["locations"].map { |obj|
        Location.new(obj)
      }
    end

    def self.get(id:, api_key: nil)
      response = api.request(
        :get,
        endpoint(id),
        api_key: api_key,
      )
      raise response.error unless response.success?

      Location.new(response.json_body)
    end

    def initialize(hash)
      set_attributes(hash)
    end

    def tickets
      @tickets ||= Ticket.all(location_id: id)
    end
  end
end
