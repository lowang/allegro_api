require 'csv'

module Helpers
  def stub_wsdl_request_for(url)
    stub_request(:get, url).to_return(File.new(File.expand_path('../api_responses/wsdl.txt', __FILE__)))
  end

  def stub_api_response_with(response_name)
    stub_request(:post, "https://webapi.allegro.pl.webapisandbox.pl/service.php").
    to_return(File.new(File.expand_path("../api_responses/#{response_name}.txt", __FILE__)))
  end

  def populate_fields_cache
    CSV.foreach(File.expand_path("../fixtures/field_list.csv", __FILE__), headers: true, header_converters: :symbol) do |row|
      field = AllegroApi::Field.from_api(row)
      AllegroApi.cache.store(:fields, field.id, field)
    end
  end
end