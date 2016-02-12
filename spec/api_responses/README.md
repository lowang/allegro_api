stub responses like:

```ruby
  before :each do
    stub_wsdl_request_for wsdl_url
    stub_api_response_with 'do_something_success'
  end
```
