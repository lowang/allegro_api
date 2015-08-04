require 'spec_helper'
require_relative '../test_cache'

describe AllegroApi::Repository::Transaction do

  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }
  let(:client) { AllegroApi::Client.new wsdl: wsdl_url }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }
  let(:transactions_repository) { session.transactions }

  describe '#find' do
    subject { transactions_repository.seller.find([1,2,3]) }
    it 'invokes doGetPostBuyFormsDataForSellers SOAP request' do
      expect(client).to receive(:call).with(:do_get_post_buy_forms_data_for_sellers, session_id: 1234,
        transactions_ids_array: [{:item=>1}, {:item=>2}, {:item=>3}]).and_return({do_get_post_buy_forms_data_for_sellers_response: {post_buy_form_data: {}}})
      subject
    end

    context 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_post_buy_forms_data_for_sellers_success'
      end

      it 'returns list of transactions' do
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 1
        expect(subject).to all(be_instance_of AllegroApi::Transaction)
      end
    end
  end
end
