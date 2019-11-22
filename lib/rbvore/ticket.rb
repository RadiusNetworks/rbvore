# frozen_string_literal: true

module Rbvore
  class Ticket < Resource
    attr_accessor :id, :pos_id, :guest_count, :name, :open, :ticket_number, :totals,
                  :location_id, :auto_send, :fire_date, :fire_time, :ready_date,
                  :ready_time, :void
    attr_timestamp_accessor :closed_at, :opened_at
    attr_collections(
      items: Item,
      payments: Payment,
      service_charges: TicketServiceCharge,
      discounts: TicketDiscount,
      voided_items: VoidedItem,
    )
    attr_objects(
      table: Table,
      employee: Employee,
      order_type: OrderType,
      revenue_center: RevenueCenter,
    )

    def self.fetch_all(location_id:, open: nil, table_id: nil, api_key: nil)
      super(
        location_id: location_id,
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
