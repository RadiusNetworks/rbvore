# frozen_string_literal: true

module Rbvore
  class TicketServiceCharge < Resource
    attr_accessor :id, :name, :price, :comment

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
