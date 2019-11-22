# frozen_string_literal: true

module Rbvore
  class MenuItem < Resource
    attr_accessor :id, :barcodes, :in_stock, :name, :open, :pos_id, :price_per_unit

    attr_collections menu_categories: MenuCategory

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
