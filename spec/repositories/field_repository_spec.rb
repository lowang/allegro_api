require 'spec_helper'
require_relative '../test_cache'

describe AllegroApi::Repository::Field do

  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }
  let(:webapi_key) { '12345' }
  let(:client) { AllegroApi::Client.new wsdl: wsdl_url, webapi_key: webapi_key }
  let(:fields_repository) { client.fields }

  describe '#to_a' do
    subject { fields_repository.to_a }

    it 'invokes SOAP request' do
      expect(client).to receive(:call).with(:do_get_sell_form_fields_ext,
        country_code: 1, local_version: 0, webapi_key: webapi_key).
        and_return({ do_get_sell_form_fields_ext_response: { sell_form_fields: { item: [] } } })
      subject
    end

    describe 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_sell_form_fields_ext_success'
      end

      it 'returns an array of fields' do
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 5182
        expect(subject).to all(be_instance_of AllegroApi::Field)
      end
    end
  end
  describe '#first' do
    before :each do
      stub_wsdl_request_for wsdl_url
      stub_api_response_with 'do_get_sell_form_fields_ext_success'
    end
    it 'only process single element' do
      expect(AllegroApi::Field).to receive(:from_api).once.and_call_original
      expect(fields_repository.first).to be_instance_of AllegroApi::Field
    end
    it 'has 5k+ elements but using enumerator it only calls AllegroApi::Field.from_api once in above example' do
      expect(fields_repository.to_a.count).to eq(5182)
    end
  end
end
