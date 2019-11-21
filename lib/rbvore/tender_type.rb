# frozen_string_literal: true

module Rbvore
  class TenderType < Resource
    attr_accessor :id, :allows_tips, :name, :pos_id

    def initialize(hash)
      set_attributes(hash)
    end
  end
end
