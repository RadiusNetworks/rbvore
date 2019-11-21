# frozen_string_literal: true

module Rbvore
  class Table < Resource
    attr_accessor :id, :available, :name, :number, :pos_id, :seats
    attr_collections open_tickets: "ticket"
    attr_objects revenue_center: "revenue_center"

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
