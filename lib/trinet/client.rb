require 'faraday'
require 'faraday_middleware'

require 'trinet/version'
require 'trinet/configuration'
require 'trinet/client/employees'
require 'trinet/client/companies'

module Trinet
  class RequestError < StandardError; end

  class Client
    include Trinet::Client::Employees
    include Trinet::Client::Companies

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      options = Trinet.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send key
      end
      conf
    end

    private

    def get(path, params = nil)
      # TODO: Remove this after Authorization header is fully supported
      params ||= {}
      params[:apikey] ||= api_key
      request(:get, path, params)
    end

    def post(path, params, options = nil)
      request(:post, path, params, options)
    end

    def patch(path, params, options = nil)
      request(:patch, path, params, options)
    end

    def delete(path, params = nil)
      request(:delete, path, params)
    end

    def request(method, path, parameters = nil, options = nil)
      response = connection.send(method.to_sym, path, parameters) do |req|
        req.headers["Authorization"] = "apikey #{api_key}"
      end
      response["data"]
    rescue Faraday::Error::ClientError
      raise Trinet::RequestError, $!, $!.backtrace
    end

    def connection
      Faraday.new(endpoint) do |conn|
        conn.use Faraday::Response::RaiseError
        conn.request :url_encoded
        conn.response :json, :content_type => /\bjson$/
        conn.adapter adapter
        conn.headers[:user_agent] = user_agent
        conn.response :logger if ENV["DEBUG"]
      end
    end

  end
end