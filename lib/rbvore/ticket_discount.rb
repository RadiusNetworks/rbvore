# frozen_string_literal: true

module Rbvore
  class TicketDiscount < Resource
    attr_accessor :id, :name, :value, :comment
    attr_objects discount: Discount

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
