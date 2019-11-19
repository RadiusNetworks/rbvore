# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'forwardable'

module Rbvore
  class API
    DEFAULT_HOST = ENV.fetch("OMNIVORE_HOST", "api.omnivore.io")
    DEFAULT_API_KEY = ENV.fetch("OMNIVORE_API_KEY", nil)

    class Error < Error
      extend Forwardable
      attr_reader :response
      def_delegators :response, :code, :body, :json_body, :uri

      def initialize(message = nil, response:)
        @response = response
        @message = message || [response.code, response.message].join(" ")
        super(@message)
      end
    end

    class Response
      extend Forwardable

      attr_reader :original
      def_delegators :original, :code, :body, :uri, :msg, :message, :inspect, :content_type

      def initialize(obj)
        @original = obj
      end

      def json_body
        @json_body ||= JSON.parse(body)
      end

      def success?
        original.is_a?(Net::HTTPSuccess)
      end

      def error
        API::Error.new(response: self) unless success?
      end
    end

    def initialize(host = DEFAULT_HOST)
      @host = host
    end

    # rubocop:disable Metrics/MethodLength,Metrics/ParameterLists
    def request(method, endpoint, body: nil, params: {}, headers: {}, api_key: nil)
      api_key ||= DEFAULT_API_KEY
      uri = build_uri(endpoint, params)
      http_start(uri) { |http|
        http.request(
          build_request(
            method,
            uri,
            body: body,
            headers: headers,
            api_key: api_key,
          ),
        )
      }
      # rubocop:enable Metrics/MethodLength,Metrics/ParameterLists
    end

  private

    def build_uri(endpoint, params = nil)
      url = if endpoint.start_with? "http"
              endpoint
            else
              "https://#{@host}#{endpoint}"
            end

      URI.parse(url).tap { |uri|
        next if params.nil? || params.empty?

        uri.query = Resource.encode_form_data(params)
      }
    end

    def build_request(method, uri, body: nil, headers: {}, api_key: nil) # rubocop:disable Metrics/MethodLength
      method_class = case method
                     when :get
                       Net::HTTP::Get
                     when :post
                       Net::HTTP::Post
                     end
      method_class.new(uri.request_uri).tap { |r|
        headers.each do |key, value|
          r.add_field(key, value)
        end
        r.add_field "Accept", "application/json"
        r.add_field "Api-Key", api_key unless api_key.nil?

        if body.is_a? String
          r.body = body
        elsif !body.nil?
          r.add_field "Content-Type", "application/json"
          r.body = body.to_json
        end
      }
    end

    def http_start(uri, &block)
      Response.new(Net::HTTP.start(uri.host, uri.port, http_opts, &block))
    end

    def http_opts
      { use_ssl: true }
    end
  end
end
