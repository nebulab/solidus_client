# frozen_string_literal: true

require 'solidus_client/cli'

RSpec.describe SolidusClient::CLI do
  let(:cli) { described_class.new }
  let(:client) { instance_spy(SolidusClient::Client) }

  it 'prints commands in help' do
    ARGV.replace(%w[-h])
    expect { cli.run }.to raise_error(SystemExit)
      .and output(/ create_order /).to_stdout
  end

  it 'parses json data' do
    ARGV.replace(%w[create_order {"a_key":"a_value"}])
    allow(PP).to receive(:pp)
    allow(SolidusClient::Client).to receive(:new).and_return(client)

    cli.run

    expect(client).to have_received(:create_order).with(a_key: 'a_value')
  end

  it 'parses url option' do
    ARGV.replace(%w[-u a_url create_order some_data])
    allow(PP).to receive(:pp)
    expect(SolidusClient::Client).to receive(:new)
      .with(url: 'a_url')
      .and_return(instance_double(SolidusClient::Client).as_null_object)

    cli.run
  end

  it 'parses key option' do
    ARGV.replace(%w[-k an_api_key create_order some_data])
    allow(PP).to receive(:pp)
    expect(SolidusClient::Client).to receive(:new)
      .with(api_key: 'an_api_key')
      .and_return(instance_double(SolidusClient::Client).as_null_object)

    cli.run
  end

  it 'parses token option' do
    ARGV.replace(%w[-t a_guest_token create_order some_data])
    allow(PP).to receive(:pp)
    expect(SolidusClient::Client).to receive(:new)
      .with(guest_token: 'a_guest_token')
      .and_return(instance_double(SolidusClient::Client).as_null_object)

    cli.run
  end

  it 'runs a command' do
    ARGV.replace(%w[create_order some_data])
    allow(SolidusClient::Client).to receive(:new).and_return(client)
    expect(client).to receive(:create_order)
      .with('some_data')
      .and_return('an_output')

    expect { cli.run }.to output(/an_output/).to_stdout
  end
end
