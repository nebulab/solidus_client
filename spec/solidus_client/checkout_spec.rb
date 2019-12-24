# frozen_string_literal: true

RSpec.describe 'Checkout flow' do
  let(:client) { SolidusClient::Client.new }

  before do
    create_product
  end

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

    expect(order[:state]).to eq('complete')
  end
end
