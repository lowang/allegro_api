require 'spec_helper'

describe AllegroApi::Repository::PurchaseDetail do

  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }
  let(:client) { AllegroApi::Client.new wsdl: wsdl_url }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }
  let(:purchase_details_repository) { session.purchase_details }

  describe '#find' do
    before do
      stub_wsdl_request_for wsdl_url
      stub_api_response_with 'do_get_post_buy_data_success'
    end

    context 'on success' do
      subject { purchase_details_repository.find(5556661234) }

      it 'returns list of transactions' do
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 2
        expect(subject).to all(be_instance_of AllegroApi::PurchaseDetail)
      end

      context 'multiple results' do
        before do
          stub_api_response_with 'do_get_post_buy_data_array_success'
        end
        it 'returns list of transactions' do
          expect(subject).to be_instance_of Array
          expect(subject.first.item_id).to eq 5556661234
          expect(subject.first.user.login).to eq 'tomaszk200'
          expect(subject.last.item_id).to eq 5556661235
        end
      end
    end
  end
end
