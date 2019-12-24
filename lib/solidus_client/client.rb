# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'pp'

module SolidusClient
  # Solidus API Client entrypoint
  class Client
    def initialize(url: nil, api_key: nil)
      url ||= ENV['SOLIDUS_URL']
      api_key ||= ENV['SOLIDUS_API_KEY']

      @connection = Faraday.new(url: url + '/api') do |connection|
        connection.authorization(:Bearer, api_key)
        connection.use Faraday::Response::RaiseError
        connection.headers['Content-Type'] = 'application/json'
        connection.request(:json)
        connection.response(:json, parser_options: { symbolize_names: true })
        connection.adapter Faraday.default_adapter
      end
    end

    def states(country_id)
      get("countries/#{country_id}/states")
    end

    def shipping_zones
      get('zones')
    end

    def products
      get('products')
    end

    def create_product(data = {})
      post('products', data)
    end

    def create_order(data = {})
      post('orders', data)
    end

    def add_item(order_number, data = {})
      post("orders/#{order_number}/line_items", data)
    end

    def remove_item(order_number, item_id)
      delete("orders/#{order_number}/line_items/#{item_id}")
    end

    def advance_checkout(order_number)
      put("checkouts/#{order_number}/next")
    end

    def complete_checkout(order_number)
      put("checkouts/#{order_number}/complete")
    end

    def update_order(order_number, data)
      patch("orders/#{order_number}", data)
    end

    def shipping_rates(shipment_number)
      get("shipments/#{shipment_number}/estimated_rates")
    end

    def payments
      get('products')
    end

    def select_shipping_method(shipment_number, data)
      put("shipments/#{shipment_number}/select_shipping_method", data)
    end

    def enter_payment_details(order_number, data)
      post("orders/#{order_number}/payments", data)
    end

    private

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

    def request(method, path, data = nil)
      @connection.send(method, path, data).body
    rescue Faraday::ClientError => e
      pp e.response[:body]
      raise
    end
  end
end
