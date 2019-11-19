# frozen_string_literal: true

module Rbvore
  class OrderType < Resource
    attr_accessor :id, :name, :pos_id, :available

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
