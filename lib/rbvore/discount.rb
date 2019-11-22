# frozen_string_literal: true

module Rbvore
  class Discount < Resource
    attr_accessor :id, :available, :max_amount, :max_percent, :min_amount, :min_percent,
                  :min_ticket_total, :name, :open, :pos_id, :type, :value, :applies_to

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
