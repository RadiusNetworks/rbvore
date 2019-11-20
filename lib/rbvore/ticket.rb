# frozen_string_literal: true

module Rbvore
  class Ticket < Resource
    ENDPOINT = "/tickets"

    attr_accessor :id, :guest_count, :name, :open, :ticket_number, :totals, :void,
                  :location_id
    attr_timestamp_accessor :closed_at, :opened_at
    attr_collections(
      items: Item,
      payments: Payment,
      service_charges: TicketServiceCharge,
      discounts: TicketDiscount,
    )
    attr_objects(
      table: Table,
      employee: Employee,
      order_type: OrderType,
      revenue_center: RevenueCenter,
    )

    def self.api
      @api ||= API.new
    end

    def self.endpoint(location_id, ticket_id = nil)
      if ticket_id.nil?
        Location.endpoint(location_id) + ENDPOINT
      else
        Location.endpoint(location_id) + ENDPOINT + "/#{ticket_id}"
      end
    end

    def self.all(location_id:, open: nil, table_id: nil, api_key: nil)
      api.fetch_all(
        endpoint(location_id),
        Ticket,
        params: build_where_clause(open: open, table_id: table_id),
        api_key: api_key,
      )
    end

    def self.build_where_clause(open: nil, table_id: nil) # rubocop:disable Metrics/CyclomaticComplexity
      case
      when !open.nil? && table_id.nil?
        { where: "eq(open,#{open})" }
      when open.nil? && !table_id.nil?
        { where: "eq(@table.id,'#{table_id}')" }
      when !open.nil? && !table_id.nil?
        { where: "and(eq(open,#{open}),eq(@table.id,'#{table_id}'))" }
      end
    end

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
