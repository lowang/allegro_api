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

## Development

when creating new method accessing soap api, create new spec and make it call and save original request for further testing:

```ruby
let(:wsdl_url) { 'https://webapi.allegro.pl/service.php?wsdl' }
let(:webapi_key) { 'YOURREALKEY' }
let(:session) { client.sign_in 'REALOGIN', AllegroApi::Client.encode_password('PASSWORD') }
let(:client) { AllegroApi::Client.new wsdl: wsdl_url, webapi_key: webapi_key, logger: Logger.new(STDOUT), log_level: :debug  }

it 'calls new method' do
  WebMock.disable!
  session.repository.method
  File.open(AllegroApi.root + '/spec/api_responses/do_something_success.txt', 'w+') { |f| f.write "HTTP/1.1 200 OK\n\n" + client.last_soap_response.http.raw_body }
```

then you can stub it like:
      
```ruby
  before :each do
    stub_wsdl_request_for wsdl_url
    stub_api_response_with 'do_something_success'
  end
```

## Contributing
   
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Check out spec-s to find out more.

