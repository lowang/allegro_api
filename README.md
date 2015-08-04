# AllegroApi

A simple attempt to wrap AllegroApi SOAP requests into something restful.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'allegro_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allegro_api

## Usage

```ruby
require 'allegro_api'
client = AllegroApi::Client.new wsdl: "https://webapi.allegro.pl/service.php?wsdl", webapi_key: "YOUR_KEY", log_level: :debug, logger: Logger.new(STDOUT)
session = client.sign_in "YOUR_LOGIN", AllegroApi::Client.encode_password("YOUR_PASSWORD")
```

### Fetch categories

```ruby
session.categories.to_a
```

### Fetch sold items

```ruby
session.items.sold.to_a
```

Check out spec-s to find out more.

