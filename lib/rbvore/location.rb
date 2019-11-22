# frozen_string_literal: true

module Rbvore
  class Location < Resource
    attr_accessor :address, :concept_name, :display_name, :name, :id, :custom_id,
                  :google_place_id, :health, :latitude, :longitude, :owner, :phone,
                  :pos_type, :status, :timezone, :website, :development
    attr_timestamp_accessor :created, :modified
    attr_collections(
      tender_types: TenderType,
      employees: Employee,
      tables: Table,
      order_types: OrderType,
      revenue_centers: RevenueCenter,
      tickets: Ticket,
    )

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
