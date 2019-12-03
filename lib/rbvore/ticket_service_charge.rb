# frozen_string_literal: true

module Rbvore
  class TicketServiceCharge < Resource
    attr_accessor :id, :name, :price, :comment

    def initialize(hash)
      set_attributes(hash)
    end

    def self.create(location_id:, ticket_id:, name:, amount:, api_key: nil)
      response = api.request(
        :post,
        API.endpoint(Location, location_id, Ticket, ticket_id, "service_charges"),
        body: [{ service_charge: name, amount: amount }],
        api_key: api_key,
      )
      raise response.error unless response.success?

      TicketServiceCharge.new(response.json_body)
    end
  end
end
