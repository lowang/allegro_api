require 'spec_helper'
require_relative '../test_cache'

describe AllegroApi::Repository::Category do

  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }
  let(:webapi_key) { '12345' }
  let(:client) { AllegroApi::Client.new wsdl: wsdl_url, webapi_key: webapi_key }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }

  describe '#to_a' do
    subject { session.categories.to_a }

    it 'invokes SOAP request' do
      expect(client).to receive(:call).with(:do_get_cats_data,
        country_id: 1, local_version: 0, webapi_key: webapi_key).
        and_return({do_get_cats_data_response: {cats_list: {item: []}}})
      subject
    end

    describe 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_cats_data_success'
      end

      it 'returns an array of fields' do
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 23817
        expect(subject).to all(be_instance_of AllegroApi::Category)
      end
    end
  end
end
