# frozen_string_literal: true

module Rbvore
  class RevenueCenter < Resource
    attr_accessor :id, :name, :pos_id, :default

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
