# frozen_string_literal: true

module Rbvore
  class ItemModifier < Resource
    attr_accessor :id, :name, :price, :quantity, :comment

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
