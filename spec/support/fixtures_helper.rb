require 'pathname'

module Rbvore
  module RSpec
    module FixtureHelpers
      def api_response(code, fixture)
        pathname = Pathname.new("spec/fixtures/responses").join(fixture)
        klass = Net::HTTPResponse.send(:response_class, code.to_s)
        underlying = klass.new("1.1", code.to_s, "")
        allow(underlying).to receive(:body) { pathname.read }
        API::Response.new(underlying)
      end

      def set_api_response(code, fixture)
        allow(Net::HTTP).to receive(:start).and_raise("API REQUESTS DISABLED")
        allow_any_instance_of(Rbvore::API).to receive(:request) { api_response(code, fixture) }
      end
    end
  end
end
