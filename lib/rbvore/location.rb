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

    def self.all(params: {}, api_key: nil)
      api.fetch_all(
        ENDPOINT,
        Location,
        params: params,
        api_key: api_key,
      )
    end

    def self.get(id:, params: {}, api_key: nil)
      api.fetch_one(
        endpoint(id),
        Location,
        params: params,
        api_key: api_key,
      )
    end

    def initialize(hash)
      set_attributes(hash)
    end

    def tickets
      @tickets ||= Ticket.all(location_id: id)
    end
  end
end
