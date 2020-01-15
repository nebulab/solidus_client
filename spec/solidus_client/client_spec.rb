# frozen_string_literal: true

RSpec.describe SolidusClient::Client do
  let(:client) { described_class.new }

  it 'gets data from server' do
    response = client.states(1)

    expect(response[:states].first).to include(:id, :name, :country_id)
  end

  it 'handles errors' do
    ENV.delete('SOLIDUS_GUEST_TOKEN')
    ENV['SOLIDUS_API_KEY'] = 'invalid_key'
    allow(PP).to receive(:pp)

    expect { client.products }.to raise_error
      .and output(/Invalid API key/).to_stderr
  end
end
