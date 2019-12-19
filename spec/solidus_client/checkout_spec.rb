# frozen_string_literal: true

RSpec.describe 'Checkout flow' do
  let(:client) { SolidusClient::Client.new }

  it 'completes successfully' do
    create_order
    add_item
    advance_checkout
    enter_address
    advance_checkout
    select_shipping_method
    advance_checkout
    enter_payment_details
    advance_checkout
    complete_checkout
  end

  def create_order
    @order = client.create_order(email: 'test@example.com')
  end

  def advance_checkout
    @order = client.advance_checkout(@order[:number])
  end

  def add_item
    product = client.products[:products].first
    variant_id = product.dig(:variants).first[:id] || product.dig(:master)[:id]
    client.add_item(@order[:number], quantity: 1, variant_id: variant_id)
  end

  def enter_address
    country_id = first_country_id
    state_id = first_state_id
    address = default_address.merge(country_id: country_id, state_id: state_id)
    @order = client.update_order(
      @order[:number],
      use_billing: true,
      bill_address_attributes: address,
      ship_address_attributes: address
    )
  end

  def select_shipping_method
    shipment_number = @order[:shipments].first[:number]
    shipping_method_id = @order[:shipments]
                         .first[:shipping_rates]
                         .first[:shipping_method_id]
    client.select_shipping_method(
      shipment_number,
      shipping_method_id: shipping_method_id
    )
  end

  def enter_payment_details
    payment_method_id = @order[:payment_methods].first[:id]
    client.enter_payment_details(
      @order[:number],
      payment: {
        amount: 10.00,
        payment_method_id: payment_method_id,
        source_attributes: default_credit_card
      }
    )
  end

  def complete_checkout
    client.complete_checkout(@order[:number])
  end

  def first_country_id
    client.shipping_zones[:zones].first[:zone_members].first[:zoneable_id]
  end

  def first_state_id
    client.states(country_id)[:states].first[:id]
  end

  def default_address
    {
      firstname: 'A firstname',
      lastname: 'A lastname',
      address1: 'A street address',
      city: 'A city',
      zipcode: 'A zip code',
      phone: 'A phone number'
    }
  end

  def default_credit_card
    {
      name: 'A name',
      number: '1',
      expiry: '01/2030',
      verification_value: '666'
    }
  end
end
