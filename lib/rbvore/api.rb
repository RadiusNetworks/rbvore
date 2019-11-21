# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'forwardable'

module Rbvore
  class API
    DEFAULT_HOST = ENV.fetch("OMNIVORE_HOST", "api.omnivore.io")
    DEFAULT_API_KEY = ENV.fetch("OMNIVORE_API_KEY", nil)
    BASE_ENDPOINT = "/1.0"

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

    def request(method, endpoint, body: nil, params: {}, headers: {}, api_key: nil) # rubocop:disable Metrics/ParameterLists
      api_key ||= DEFAULT_API_KEY
      uri = build_uri(endpoint, params)
      http_start(uri) { |http|
        http.request(
          build_request(method, uri, body: body, headers: headers, api_key: api_key),
        )
      }
    end

    def fetch_all(endpoint, resource_class, params: {}, api_key: nil)
      response = request(
        :get,
        endpoint,
        params: params,
        api_key: api_key,
      )
      raise response.error unless response.success?

      Resource.parse_collection(response.json_body, resource_class)
    end

    def fetch_one(endpoint, resource_class, params: {}, api_key: nil)
      response = request(
        :get,
        endpoint,
        params: params,
        api_key: api_key,
      )
      raise response.error unless response.success?

      Resource.parse_object(response.json_body, resource_class)
    end

    def self.endpoint(*items)
      ([BASE_ENDPOINT] + items.map { |item|
        case
        when Rbvore.resource_subclass?(item)
          item.pluralize
        when item.nil?
          nil
        else
          item.to_s
        end
      }.compact).join("/")
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

    def build_request(method, uri, body: nil, headers: {}, api_key: nil)
      method_class(method).new(uri.request_uri).tap { |r|
        headers.each do |key, value|
          r.add_field(key, value)
        end
        r.add_field "Accept", "application/json"
        r.add_field "Api-Key", api_key unless api_key.nil?
        set_body(r, body)
      }
    end

    def http_start(uri, &block)
      Response.new(Net::HTTP.start(uri.host, uri.port, http_opts, &block))
    end

    def http_opts
      { use_ssl: true }
    end

    def set_body(request, body)
      if body.is_a? String
        request.body = body
      elsif !body.nil?
        request.add_field "Content-Type", "application/json"
        request.body = body.to_json
      end
    end

    def method_class(name)
      case name.to_sym
      when :get
        Net::HTTP::Get
      when :post
        Net::HTTP::Post
      end
    end
  end
end
