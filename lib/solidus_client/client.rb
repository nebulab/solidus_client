# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'pp'
require 'solidus_client/connection'

module SolidusClient
  # Solidus API Client entrypoint
  class Client
    def initialize(url: nil, api_key: nil, guest_token: nil)
      url ||= ENV['SOLIDUS_URL']
      api_key ||= ENV['SOLIDUS_API_KEY']
      guest_token ||= ENV['SOLIDUS_GUEST_TOKEN']

      @connection = Connection.new(url, api_key, guest_token)
    end

    def states(country_id)
      @connection.get("countries/#{country_id}/states")
    end

    def shipping_zones
      @connection.get('zones')
    end

    def products
      @connection.get('products')
    end

    def promotions
      @connection.get('promotions')
    end

    def create_product(data = {})
      @connection.post('products', data)
    end

    def create_order(data = {})
      @connection.post('orders', data)
    end

    def add_item(order_number, data = {})
      @connection.post("orders/#{order_number}/line_items", data)
    end

    def remove_item(order_number, item_id)
      @connection.delete("orders/#{order_number}/line_items/#{item_id}")
    end

    def advance_checkout(order_number)
      @connection.put("checkouts/#{order_number}/next")
    end

    def complete_checkout(order_number)
      @connection.put("checkouts/#{order_number}/complete")
    end

    def update_order(order_number, data)
      @connection.patch("orders/#{order_number}", data)
    end

    def shipping_rates(shipment_number)
      @connection.get("shipments/#{shipment_number}/estimated_rates")
    end

    def payments
      @connection.get('products')
    end

    def select_shipping_method(shipment_number, data)
      @connection.put("shipments/#{shipment_number}/select_shipping_method", data)
    end

    def enter_payment_details(order_number, data)
      @connection.post("orders/#{order_number}/payments", data)
    end
  end
end
