# Ruby Solidus API client

## Requirements
* [MRI 2.3+](https://www.ruby-lang.org/en/downloads)
* [Solidus 2.9+](https://solidus.io) with [Solidus Auth (Devise)](https://github.com/solidusio/solidus_auth_devise)

## Installation

```
gem install solidus_client
```

## Usage

### Client class

Use `SolidusClient:Client` class
```ruby
require 'solidus_client/client'

client = SolidusClient::Client.new(url: 'app url', api_key: 'user api key')

item_data_hash = { ... }
response_hash = client.add_item(order_number, item_data_hash)
```

### Command line
Run `solidus` command

```
$ solidus -h

Usage: solidus [options] command [target] [JSON data]

Commands:
 - add_item <order_number> <data>
 - ..

Options:
    -u, --url   Solidus URL
    -k, --key   Solidus API key
    -t, --token Solidus guest token
```

## Development
Install dependencies
```
bundle install
```

Export required environment Variables
```
export SOLIDUS_API_KEY=your API key
export SOLIDUS_URL=Solidus endpoint
```

Run specs
**WARNING:** `checkout_spec.rb` requires a running Solidus instance and writes Product and Order data to it
```
bundle exec rake spec
```

## License

Copyright © 2019 [Nebulab](https://nebulab.it/).
It is free software, and may be redistributed under the terms specified in the [license](LICENSE.txt).

## About

![Nebulab](http://nebulab.it/assets/images/public/logo.svg)

Solidus API Client is funded and maintained by the [Nebulab](http://nebulab.it/) team.

We firmly believe in the power of open-source. [Contact us](https://nebulab.it/contact-us/) if you like our work and you need help with your project design or development.
