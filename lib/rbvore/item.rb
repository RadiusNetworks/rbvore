# frozen_string_literal: true

module Rbvore
  class Item < Resource
    attr_accessor :id, :name, :price, :quantity, :seat, :sent, :split
    attr_timestamp_accessor :sent_at
    attr_objects menu_item: MenuItem
    attr_collections modifiers: ItemModifier

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
