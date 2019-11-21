# frozen_string_literal: true

module Rbvore
  class Payment < Resource
    attr_accessor :id, :amount, :change, :comment, :full_name, :status, :last4, :tip, :type
    attr_objects tender_type: TenderType

    def initialize(hash)
      set_attributes(hash)
    end

    def api
      @api ||= API.new
    end

    def create_3rd_party(location_id:, ticket_id:, auto_close: false, api_key: nil)
      response = api.request(
        :post,
        self.class.endpoint(location_id: location_id, ticket_id: ticket_id),
        body: third_party_body(auto_close),
        api_key: api_key,
      )
      raise response.error unless response.success?

      Payment.new(response.json_body)
    end

    def third_party_body(auto_close)
      {
        amount: amount,
        tip: tip,
        tender_type: tender_type,
        auto_close: auto_close,
        comment: comment,
        type: "3rd_party",
      }
    end
  end
end
