# frozen_string_literal: true

module SolidusClient
  # Handles Http client settings and methods
  class Connection
    def initialize(url, api_key = nil, guest_token = nil)
      @faraday = Faraday.new(url: url + '/api') do |connection|
        connection.authorization(:Bearer, api_key)
        connection.headers['X-Spree-Order-Token'] = guest_token
        connection.headers['Content-Type'] = 'application/json'
        connection.request(:json)
        connection.response(:json, parser_options: { symbolize_names: true })
        connection.use(Faraday::Response::RaiseError)
        connection.adapter(Faraday.default_adapter)
      end
    end

    def get(path)
      request(:get, path)
    end

    def post(path, data = {})
      request(:post, path, data)
    end

    def put(path, data = {})
      request(:put, path, data)
    end

    def patch(path, data = {})
      request(:patch, path, data)
    end

    def delete(path)
      request(:delete, path)
    end

    private

    def request(method, path, data = nil)
      @faraday.send(method, path, data).body
    rescue Faraday::ClientError => e
      pp e.response[:body]
      raise
    end
  end
end
