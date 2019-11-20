# frozen_string_literal: true

module Rbvore
  class TenderType < Resource
    ENDPOINT = "/tender_types"

    attr_accessor :id, :allows_tips, :name, :pos_id

    def initialize(hash)
      set_attributes(hash)
    end

    def self.api
      @api ||= API.new
    end

    def self.endpoint(location_id)
      Location.endpoint(location_id) + ENDPOINT
    end

    def self.all(location_id:, params: {}, api_key: nil)
      api.fetch_all(
        endpoint(location_id),
        TenderType,
        params: params,
        api_key: api_key,
      )
    end
  end
end
