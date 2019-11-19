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

    def self.all(location_id:, api_key: nil)
      response = api.request(
        :get,
        endpoint(location_id),
        api_key: api_key,
      )
      raise response.error unless response.success?

      response.json_body["_embedded"]["tender_types"].map { |obj|
        TenderType.new(obj)
      }
    end
  end
end
