# frozen_string_literal: true

module Rbvore
  class Resource
    module Fetchers
      def api
        @api ||= API.new
      end

      def endpoint(id: nil, location_id: nil, ticket_id: nil) # rubocop:disable Metrics/MethodLength
        case
        when self == Location
          API.endpoint(Location, id || location_id)
        when self == Ticket
          check_required("location_id", location_id)
          API.endpoint(Location, location_id, Ticket, id || ticket_id)
        when [TenderType, Table, Employee, RevenueCenter].include?(self)
          check_required("location_id", location_id)
          API.endpoint(Location, location_id, self, id)
        else
          check_required("location_id", location_id)
          check_required("ticket_id", ticket_id)
          API.endpoint(Location, location_id, Ticket, ticket_id, self, id)
        end
      end

      def check_required(name, value)
        raise Error, "#{name} is required" if value.nil?
      end

      def fetch_one(id: nil, location_id: nil, ticket_id: nil, params: {}, api_key: nil)
        check_required("id", id)
        api.fetch_one(
          endpoint(id: id, location_id: location_id, ticket_id: ticket_id),
          self,
          params: params,
          api_key: api_key,
        )
      end

      def fetch_all(location_id: nil, ticket_id: nil, params: {}, api_key: nil)
        api.fetch_all(
          endpoint(location_id: location_id, ticket_id: ticket_id),
          self,
          params: params,
          api_key: api_key,
        )
      end
    end
  end
end
