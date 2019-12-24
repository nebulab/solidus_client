# frozen_string_literal: true

require 'solidus_client/client'
require 'solidus_client/version'
require 'json'
require 'optparse'

module SolidusClient
  # The class responsible of handling command line logic
  class CLI
    # Entry point to start the application
    def run
      client = Client.new(parse_options)
      command = ARGV.shift.to_sym
      args = convert_data_input

      result = client.send(command, *args)
      pp result
    rescue OptionParser::InvalidOption => e
      abort("#{e.message}, see 'solidus --help'")
    end

    private

    def parse_options
      options = {}
      OptionParser.new do |opts|
        opts.version = SolidusClient::Version::STRING
        opts_banner(opts)
        opts_url(opts, options)
        opts_key(opts, options)
      end.parse!

      options
    end

    def opts_banner(opts)
      opts.banner = 'Usage: solidus [options] command [target] [JSON data]'
      opts.separator('')
      opts.separator("Commands:\n - #{commands_descriptions.join("\n - ")}")
      opts.separator('')
      opts.separator('Options:')
    end

    def opts_url(opts, options)
      opts.on('-u', '--url [STRING]', 'Solidus URL') do |value|
        options[:url] = value
      end
    end

    def opts_key(opts, options)
      opts.on('-k', '--key [STRING]', 'Solidus API key') do |value|
        options[:api_key] = value
      end
    end

    def commands_descriptions
      Client.public_instance_methods(false).sort.map do |method|
        params = Client.instance_method(method).parameters
        "#{method} #{params_description(params)}"
      end
    end

    def params_description(params)
      params.map { |param| "<#{param[1]}>" }.join(' ')
    end

    def convert_data_input
      ARGV.map do |arg|
        begin
          JSON.parse(arg, symbolize_names: true)
        rescue JSON::ParserError
          arg
        end
      end
    end
  end
end
