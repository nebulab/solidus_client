# frozen_string_literal: true

module Helpers
  module CheckoutHelper
    attr_accessor :order

    TEST_PRODUCT = {
      name: 'A product',
      price: '10.00',
      shipping_category_id: 1
    }.freeze

    TEST_ADDRESS = {
      firstname: 'A firstname',
      lastname: 'A lastname',
      address1: 'A street address',
      city: 'A city',
      zipcode: 'A zip code',
      phone: 'A phone number'
    }.freeze

    TEST_CREDIT_CARD = {
      name: 'A name',
      number: '1',
      expiry: '01/1970',
      verification_value: '1'
    }.freeze

    def create_product
      client.create_product(product: TEST_PRODUCT) unless first_product
    end

    def create_order
      self.order = client.create_order(email: 'test@example.com')
    end

    def advance_checkout
      self.order = client.advance_checkout(order_number)
    end

    def add_item
      client.add_item(
        order_number,
        quantity: 1,
        variant_id: first_product_variant_id
      )
    end

    def enter_address
      country_id = first_country_id
      state_id = first_state_id(country_id)
      address = TEST_ADDRESS.merge(country_id: country_id, state_id: state_id)
      self.order = client.update_order(
        order_number,
        use_billing: true,
        bill_address_attributes: address,
        ship_address_attributes: address
      )
    end

    def select_shipping_method
      client.select_shipping_method(
        first_shipment_number,
        shipping_method_id: first_shipping_method_id
      )
    end

    def enter_payment_details
      client.enter_payment_details(
        order_number,
        payment: {
          amount: 10.00,
          payment_method_id: first_payment_method_id,
          source_attributes: TEST_CREDIT_CARD
        }
      )
    end

    def complete_checkout
      self.order = client.complete_checkout(order_number)
    end

    private

    def order_number
      order[:number]
    end

    def first_product
      client.products[:products].first
    end

    def first_product_variant_id
      product = first_product
      variant = product[:variants].first || product[:master]
      variant[:id]
    end

    def first_country_id
      client.shipping_zones[:zones].first[:zone_members].first[:zoneable_id]
    end

    def first_state_id(country_id)
      client.states(country_id)[:states].first[:id]
    end

    def first_payment_method_id
      order[:payment_methods].first[:id]
    end

    def first_shipment_number
      order[:shipments].first[:number]
    end

    def first_shipping_method_id
      order[:shipments].first[:shipping_rates].first[:shipping_method_id]
    end
  end
end
