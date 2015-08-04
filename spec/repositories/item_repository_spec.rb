require 'spec_helper'

describe AllegroApi::Repository::Item do

  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }
  let(:client) { AllegroApi::Client.new wsdl: wsdl_url }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }
  let(:items_repository) { session.items }

  describe '#each' do
    let(:items) do
      7.times.map { |i| item = AllegroApi::Item.new; item.id = i; item }
    end

    let(:in_block_code) { double }

    it 'performs code of the block for each page of events' do
      expect(items_repository).to receive(:get_items).and_return([items.size, items[0..3]], [items.size,items[4..6]])
      expect(in_block_code).to receive(:call).with(AllegroApi::Item).exactly(7).times
      item_ids = []
      items_repository.each {|item| item_ids  << item.id; in_block_code.call(item) }
      expect(item_ids).to eq([0,1,2,3,4,5,6])
    end
  end

  describe '#size' do
    it 'fetches counter from get_items' do
      expect(items_repository).to receive(:get_items).and_return([777, []])
      expect(items_repository.size).to eq(777)
    end
  end

  describe '#find' do
    let(:api_response) do
      {do_get_my_sell_items_response: {sell_items_counter: "0", sell_items_list: {item: []}}}
    end

    it 'respects list of items ids provided and given item_type' do
      expect(client).to receive(:call).with(:do_get_my_sell_items, session_id: session_id,
        item_ids: {item: [1, 2, 3, 4]}).and_return(api_response)
      items_repository.sell.find([1, 2, 3, 4])
    end
  end

  describe '#to_a' do
    subject { items_repository.sell.to_a }

    context 'when number of items exceeds one page' do
      let(:first_page_params) do
        {session_id: 1234, page_size: 100, page_number: 0}
      end
      let(:second_page_params) do
        {session_id: 1234, page_size: 100, page_number: 1}
      end

      let(:items) do
        [{item_id: "4762577271", item_title: "inny test", item_thumbnail_url: nil, item_price: {item: {price_type: "1", price_value: "5.55"}},
          item_start_quantity: "2", item_sold_quantity: "0", item_quantity_type: "1", item_start_time: "1420216922",
          item_end_time: "1421080922", item_end_time_left: "9 dni", item_bidders_counter: "0",
          item_highest_bidder: {user_id: "0", user_login: nil, user_rating: "0", user_icons: "0", user_country: "0"},
          item_category_id: "101360", item_watchers_counter: "0", item_views_counter: "0", item_note: nil, item_special_info: "0",
          item_shop_info: "0", item_product_info: "0", item_payu_info: "0", item_duration_info: {duration_type: "1"}},
         {item_id: "4762570616", item_title: "sdsdsdsd", item_thumbnail_url: nil, item_price: {item: {price_type: "1", price_value: "10"}},
          item_start_quantity: "1", item_sold_quantity: "0", item_quantity_type: "1", item_start_time: "1420211678", item_end_time: "1422803678",
          item_end_time_left: "29 dni", item_bidders_counter: "0", item_highest_bidder: {user_id: "0", user_login: nil, user_rating: "0",
          user_icons: "0", user_country: "0"}, item_category_id: "101368", item_watchers_counter: "0", item_views_counter: "2", item_note: nil,
          item_special_info: "0", item_shop_info: "0", item_product_info: "0", item_payu_info: "0", item_duration_info: {duration_type: "1"}}]
      end

      let(:first_api_response) do
        { do_get_my_sell_items_response: {sell_items_counter: "2", sell_items_list: {item: [items[0]]}}}
      end
      let(:second_api_response) do
        { do_get_my_sell_items_response: {sell_items_counter: "2", sell_items_list: {item: [items[1]]}}}
      end

      before do
        expect(client).to receive(:call).once.ordered.with(:do_get_my_sell_items, first_page_params).and_return(first_api_response)
        expect(client).to receive(:call).once.ordered.with(:do_get_my_sell_items, second_page_params).and_return(second_api_response)
      end

      it 'retrives all pages' do
        subject
      end

      it 'concatenates items from all pages' do
        expect(subject.size).to eq 2
        expect(subject.collect {|item| item.id}).to eq([4762577271,4762570616])
      end
    end

    context 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_my_sell_items_success'
      end

      it 'returns an array of items' do
        expect(subject).to be_instance_of Array
        expect(subject.size).to eq 2
        expect(subject).to all(be_instance_of AllegroApi::Item)
      end
    end
  end

  describe 'scopes' do
    it 'sets sell_items scope' do
      items_repository.sell
      expect(items_repository.send(:scope)).to eq(:sell_items)
    end

    it 'sets sold_items scope' do
      items_repository.sold
      expect(items_repository.send(:scope)).to eq(:sold_items)
    end

    it 'sets not_sold_items scope' do
      items_repository.not_sold
      expect(items_repository.send(:scope)).to eq(:not_sold_items)
    end
  end

  describe '#search' do
    it 'sets sell_items scope' do
      items_repository.search('pinezka')
      expect(items_repository.instance_variable_get('@search_phrase')).to eq('pinezka')
    end
  end

  describe '(private)#build_params' do
    subject{ items_repository.send(:build_params) }
    it 'constructs ordered params' do
      items_repository.sell.search('pinezka')
      params = ActiveSupport::OrderedHash.new
      params[:session_id] = 1234
      params[:page_size] = 100
      params[:page_number] = 0
      params[:search_value] = "pinezka"
      expect(subject).to eq(params)
    end
  end
end
