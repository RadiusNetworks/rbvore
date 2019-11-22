# frozen_string_literal: true

module Rbvore
  class MenuCategory < Resource
    attr_accessor :id, :level, :name, :pos_id

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
