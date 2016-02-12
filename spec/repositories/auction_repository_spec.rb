require 'spec_helper'
require_relative '../test_cache'

describe AllegroApi::Repository::Item do

  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }
  let(:webapi_key) { '12345' }
  let(:client) { AllegroApi::Client.new wsdl: wsdl_url, webapi_key: webapi_key }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }
  let(:auctions_repository) { session.auctions }

  describe '#each' do
    let(:item1) { AllegroApi::Item.new }
    let(:auction1) { AllegroApi::Auction.new }
    let(:item2) { AllegroApi::Item.new }
    let(:auction2) { AllegroApi::Auction.new }

    before :each do
      item1.id = 1234
      auction1.id = 1234
      item2.id = 5678
      auction2.id = 5678
      allow(session).to receive(:items).and_return(AllegroApi::Repository::Item.new(session))
      allow(session.items).to receive(:each).and_yield(item1).and_yield(item2)
      allow(auctions_repository).to receive(:find)
    end

    subject { auctions_repository.sold.to_a }
    it 'requests items' do
      subject
      expect(session.items).to have_received(:each)
    end

    it 'retrives auction data for each item' do
      expect(auctions_repository).to receive(:find).with(1234).once.ordered.and_return(auction1)
      expect(auctions_repository).to receive(:find).with(5678).once.ordered.and_return(auction2)
      expect(subject).to eq([auction1, auction2])
    end
  end

  describe '#find' do
    it 'invokes doGetItemFields SOAP request' do
      expect(client).to receive(:call).with(:do_get_item_fields,
        session_id: 1234, item_id: 4567).and_return(
          {do_get_item_fields_response: {item_fields: {item: []}}})
      auctions_repository.find(4567)
    end

    context 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_item_fields_success'
        AllegroApi.cache = TestCache.new
        populate_fields_cache
      end

      after :each do
        AllegroApi.cache = nil
      end

      it 'returns auction auction instance' do
        expect(auctions_repository.find(4567)).to be_instance_of(AllegroApi::Auction)
      end

      describe 'returned auction' do
        subject  { auctions_repository.find(4567) }

        it 'has fields initialized' do
          expect(subject.fields.size).to eq 24
        end

        it 'has category set' do
          expect(subject.fields[2]).to eq 8849
        end

        it 'has name set' do
          expect(subject.fields[1]).to eq "aukcja z obrazkami"
        end

        it 'has id set' do
          expect(subject.id).to eq 4567
        end
      end
    end
  end

  describe '#create' do
    let(:auction) { AllegroApi::Auction.new }
    subject { auctions_repository.create(auction) }

    it 'invokes doNewAuctionExt SOAP request' do
      expect(client).to receive(:call).with(:do_new_auction_ext,
        session_handle: session.id,
        fields: {item: auction.to_api}).and_return(
          {do_new_auction_ext_response: {item_id: '123', item_info: '2,22 zł'}})
      subject
    end

    context 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_new_auction_ext'
      end

      it 'returns hash with id and cost' do
        expect(subject).to be_instance_of(Hash)
        expect(subject[:id]).to eq 4762580093
        expect(subject[:cost]).to eq 0.25
      end
    end
  end

  describe '#update' do
    let(:auction) do
      AllegroApi::Auction.new.tap do |auction|
        auction.id = 5983475459
        auction.fields[1] = "Ruby on Rails Baseball Jersey "
        auction.fields[8] = 19.99
        auction.fields[24]=
          "<h1>Ruby on Rails Baseball Jersey </h1><p>Eos enim id. Autem sunt velit sunt dolorem aspernatur eius libero. Natus quia in esse illo fuga. In sequi qui quo eum reprehenderit cupiditate ad. Quam reiciendis nostrum id sint soluta.</p>\n"
      end
    end
    context 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_change_item_fields_success'
      end
      subject { session.auctions.update(auction) }
      it { is_expected.to include({id: 5983475459}) }
      it 'sends proper xml' do
        expect(client).to receive(:call).with(:do_change_item_fields, {session_id:1234, item_id:5983475459, fields_to_modify:{
          item:[
            {fid:1, fvalue_string:"Ruby on Rails Baseball Jersey ", fvalue_int:0, fvalue_float:0, fvalue_image:"", fvalue_datetime:0,
              fvalue_date:"", fvalue_range_int: {fvalue_range_int_min:0, fvalue_range_int_max:0},
              fvalue_range_float: {fvalue_range_float_min:0, fvalue_range_float_max:0},
              fvalue_range_date: {fvalue_range_date_min:"", fvalue_range_date_max:""}},
            {fid:8, fvalue_string:"", fvalue_int:0, fvalue_float:19.99, fvalue_image:"", fvalue_datetime:0,
              fvalue_date:"", fvalue_range_int:{fvalue_range_int_min:0, fvalue_range_int_max:0},
              fvalue_range_float: {fvalue_range_float_min:0, fvalue_range_float_max:0},
              fvalue_range_date:{fvalue_range_date_min:"", fvalue_range_date_max:""}},
            {fid:24, fvalue_string: "<h1>Ruby on Rails Baseball Jersey </h1><p>Eos enim id. Autem sunt velit sunt dolorem aspernatur eius libero. Natus quia in esse illo fuga. In sequi qui quo eum reprehenderit cupiditate ad. Quam reiciendis nostrum id sint soluta.</p>\n",
              fvalue_int:0, fvalue_float:0, fvalue_image:"", fvalue_datetime:0, fvalue_date:"",
              fvalue_range_int: {fvalue_range_int_min:0, fvalue_range_int_max:0},
              fvalue_range_float:{fvalue_range_float_min:0, fvalue_range_float_max:0},
              fvalue_range_date:{fvalue_range_date_min:"", fvalue_range_date_max:""}}]
          }}).and_call_original
        subject
      end
    end
  end

end
