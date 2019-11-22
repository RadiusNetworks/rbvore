# frozen_string_literal: true

module Rbvore
  class Item < Resource
    attr_accessor :id, :name, :price, :quantity, :seat, :sent, :split, :comment
    attr_timestamp_accessor :sent_at
    attr_objects menu_item: MenuItem
    attr_collections modifiers: ItemModifier, discounts: Discount

    def initialize(hash)
      set_attributes(hash)
    end
  end

  class VoidedItem < Item; end
end
