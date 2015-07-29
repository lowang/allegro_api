require_relative './spec_helper'
require_relative './test_cache'

describe AllegroApi::Session do
  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }

  let(:client) { AllegroApi::Client.new wsdl: wsdl_url }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }

  let(:get_items_params) do
    {session_id: 1234, page_size: 100, page_number: 0}
  end

  it 'provides session id' do
    expect(session.id).to eq session_id
  end

  it 'provides user id' do
    expect(session.user_id).to eq user_id
  end

  describe '#get_items' do
    let(:api_response) do
      {do_get_my_sell_items_response: {sell_items_counter: "0", sell_items_list: {item: []}}}
    end

    it 'invokes correct SOAP request for given item_type' do
      expect(client).to receive(:call).with(:do_get_my_sell_items, session_id: session_id,
        page_size: 100, page_number: 0).and_return(api_response)
      session.get_items(:sell_items)
    end

    it 'respects list of items ids provided' do
      expect(client).to receive(:call).with(:do_get_my_sell_items, session_id: session_id,
        item_ids: {item: [1, 2, 3, 4]}).and_return(api_response)
      session.get_items(:sell_items, 1, 2, 3, 4)
    end

    context 'when number of items exceeds one page' do
      let(:second_page_params) do
        {session_id: 1234, page_size: 100, page_number: 0}
      end

      let(:api_response) do
        {do_get_my_sell_items_response: {sell_items_counter: "101", sell_items_list: {item: [
          {item_id: "4762577271", item_title: "inny test", item_thumbnail_url: nil, item_price: {item: {price_type: "1", price_value: "5.55"}},
            item_start_quantity: "2", item_sold_quantity: "0", item_quantity_type: "1", item_start_time: "1420216922",
            item_end_time: "1421080922", item_end_time_left: "9 dni", item_bidders_counter: "0",
            item_highest_bidder: {user_id: "0", user_login: nil, user_rating: "0", user_icons: "0", user_country: "0"},
            item_category_id: "101360", item_watchers_counter: "0", item_views_counter: "0", item_note: nil, item_special_info: "0",
            item_shop_info: "0", item_product_info: "0", item_payu_info: "0", item_duration_info: {duration_type: "1"}},
          {item_id: "4762570616", item_title: "sdsdsdsd", item_thumbnail_url: nil, item_price: {item: {price_type: "1", price_value: "10"}},
            item_start_quantity: "1", item_sold_quantity: "0", item_quantity_type: "1", item_start_time: "1420211678", item_end_time: "1422803678",
            item_end_time_left: "29 dni", item_bidders_counter: "0", item_highest_bidder: {user_id: "0", user_login: nil, user_rating: "0",
            user_icons: "0", user_country: "0"}, item_category_id: "101368", item_watchers_counter: "0", item_views_counter: "2", item_note: nil,
            item_special_info: "0", item_shop_info: "0", item_product_info: "0", item_payu_info: "0", item_duration_info: {duration_type: "1"}}
        ]}}}
      end

      before do
        api_response[:do_get_my_sell_items_response][:sell_items_counter] = "101"
        allow(client).to receive(:call).and_return(api_response)
      end

      it 'retrives all pages' do
        expect(client).to receive(:call).with(:do_get_my_sell_items, second_page_params)
        session.get_items(:sell_items)
      end

      it 'concatenates items from all pages' do
        expect(session.get_items(:sell_items).size).to eq 4
      end
    end


    context 'on success' do
      let(:items) { session.get_items(:sell_items) }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_my_sell_items_success'
      end

      it 'returns an array of items' do
        expect(items).to be_instance_of Array
        expect(items.size).to eq 2
        expect(items).to all(be_instance_of AllegroApi::Item)
      end
    end
  end

  describe '#get_sell_items' do
    it 'invokes get_items with sell_items' do
      expect(session).to receive(:get_items).with(:sell_items)
      session.get_sell_items
    end

    context 'for list of items' do
      it 'invokes get_items with sell_items aand list of items' do
        expect(session).to receive(:get_items).with(:sell_items, 1,2,3)
        session.get_sell_items(1,2,3)
      end
    end
  end

  describe '#get_sold_items' do
    it 'invokes get_items with sell_items' do
      expect(session).to receive(:get_items).with(:sold_items)
      session.get_sold_items
    end

    context 'for list of items' do
      it 'invokes get_items with sell_items aand list of items' do
        expect(session).to receive(:get_items).with(:sold_items, 1,2,3)
        session.get_sold_items(1,2,3)
      end
    end
  end

  describe '#get_not_sold_items' do
    it 'invokes get_items with sell_items' do
      expect(session).to receive(:get_items).with(:not_sold_items)
      session.get_not_sold_items
    end

    context 'for list of items' do
      it 'invokes get_items with sell_items aand list of items' do
        expect(session).to receive(:get_items).with(:not_sold_items, 1,2,3)
        session.get_not_sold_items(1,2,3)
      end
    end
  end

  describe "#find_auction" do
    it 'invokes doGetItemFields SOAP request' do
      expect(client).to receive(:call).with(:do_get_item_fields,
        session_id: 1234, item_id: 4567).and_return(
          {do_get_item_fields_response: {item_fields: {item: []}}})
      session.find_auction(4567)
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
        expect(session.find_auction(4567)).to be_instance_of(AllegroApi::Auction)
      end

      describe 'returned auction' do
        let(:auction)  {  session.find_auction(4567) }

        it 'has fields initialized' do
          expect(auction.fields.size).to eq 24
        end

        it 'has category set' do
          expect(auction.fields[2]).to eq 8849
        end

        it 'has name set' do
          expect(auction.fields[1]).to eq "aukcja z obrazkami"
        end

        it 'has id set' do
          expect(auction.id).to eq 4567
        end
      end
    end
  end

  describe '#create_auction' do
    let(:auction) { AllegroApi::Auction.new }

    it 'invokes doNewAuctionExt SOAP request' do
      expect(client).to receive(:call).with(:do_new_auction_ext,
        session_handle: session.id,
        fields: {item: auction.to_api}).and_return(
          {do_new_auction_ext_response: {item_id: '123', item_info: '2,22 zł'}})
      session.create_auction(auction)
    end

    context 'on success' do
      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_new_auction_ext'
      end

      it 'returns hash with id and cost' do
        response = session.create_auction(auction)
        expect(response).to be_instance_of(Hash)
        expect(response[:id]).to eq 4762580093
        expect(response[:cost]).to eq 0.25
      end
    end
  end

  describe '#auctions' do
    it 'returns enumerator' do
      expect(session.auctions).to be_instance_of(Enumerator)
    end

    describe 'enumerator' do
      let(:item1) { AllegroApi::Item.new }
      let(:auction1) { AllegroApi::Auction.new }
      let(:item2) { AllegroApi::Item.new }
      let(:auction2) { AllegroApi::Auction.new }
      let(:enumerator) { session.auctions }

      before :each do
        item1.id = 1234
        auction1.id = 1234
        item2.id = 5678
        auction2.id = 5678
        allow(session).to receive(:get_sell_items).and_return([item1, item2])
        allow(session).to receive(:find_auction).and_return(auction1, auction2)
      end

      it 'requests items' do
        enumerator.to_a
        expect(session).to have_received(:get_sell_items)
      end

      it 'retrives auction data for each item' do
        expect(session).to receive(:find_auction).with(item1.id).and_return(auction1).ordered
        expect(session).to receive(:find_auction).with(item2.id).and_return(auction2).ordered
        expect(enumerator.to_a).to eq([auction1, auction2])
      end
    end
  end

  describe '#get_site_journal_events' do
    context 'without specifying start point' do
      it 'invokes doGetSiteJournal SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal, session_handle: 1234).and_return(
            {do_get_site_journal_response: {site_journal_array: {item: []}}})
        session.get_site_journal_events
      end
    end

    context 'with starting point' do
      it 'invokes doGetSiteJournal SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal, session_handle: 1234,
          starting_point: 4321).and_return(
            {do_get_site_journal_response: {site_journal_array: {item: []}}})
        session.get_site_journal_events(4321)
      end
    end

    context 'on success' do
      let(:events) { session.get_site_journal_events }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_success'
      end

      it 'returns an array of journal events' do
        expect(events).to be_instance_of Array
        expect(events.size).to eq 5
        expect(events).to all(be_instance_of AllegroApi::JournalEvent)
      end
    end

    context 'on success without events' do
      let(:events) { session.get_site_journal_events }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_no_events'
      end

      it 'returns an empty array' do
        expect(events).to be_instance_of Array
        expect(events.size).to eq 0
      end
    end
  end

  describe '#count_site_journal_events' do
    context 'without specifying start point' do
      it 'invokes doGetSiteJournalInfo SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_info, session_handle: 1234).and_return(
          {do_get_site_journal_info_response: {site_journal_info: {items_number: 0, last_item_date: 0}}})
        session.count_site_journal_events
      end
    end

    context 'with starting point' do
      it 'invokes doGetSiteJournalInfo SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_info, session_handle: 1234,
          starting_point: 4321).and_return(
            {do_get_site_journal_info_response: {site_journal_info: {items_number: 0, last_item_date: 0}}})
        session.count_site_journal_events(4321)
      end
    end

    context 'on success' do
      let(:events_count) { session.count_site_journal_events }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_info_success'
      end

      it 'returns the number of events' do
        expect(events_count).to eq 5
      end
    end
  end

  describe '#for_each_site_journal_events_page' do
    let(:journal_events) do
      [ AllegroApi::JournalEvent.new ] * 4
    end

    let(:in_block_code) { double }

    before do
      allow(session).to receive(:count_site_journal_events).and_return(8)
      allow(session).to receive(:get_site_journal_events).and_return(journal_events)
    end

    it 'performs code of the block for each page of events' do
      expect(in_block_code).to receive(:call).with(journal_events).twice
      session.for_each_site_journal_events_page {|page| in_block_code.call(page) }
    end
  end

  describe '#get_deal_events' do
    context 'without specifying start point' do
      it 'invokes doGetSiteJournalDeals SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_deals, session_id: 1234).and_return(
            {do_get_site_journal_deals_response: {site_journal_deals: {item: []}}})
        session.get_deal_events
      end
    end

    context 'with starting point' do
      it 'invokes doGetSiteJournalDeals SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_deals, session_id: 1234,
          journal_start: 4321).and_return(
          {do_get_site_journal_deals_response: {site_journal_deals: {item: []}}})
        session.get_deal_events(4321)
      end
    end

    context 'on success without events' do
      let(:events) { session.get_deal_events }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_deals_success'
      end

      it 'returns an array of deal events' do
        expect(events).to be_instance_of Array
        expect(events.size).to eq 1
        expect(events).to all(be_instance_of AllegroApi::DealEvent)
      end
    end


    context 'on success without events' do
      let(:events) { session.get_deal_events }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_deals_no_events'
      end

      it 'returns an array of journal events' do
        expect(events).to be_instance_of Array
        expect(events.size).to eq 0
      end
    end
  end

  describe '#count_deal_events' do
    context 'without specifying start point' do
      it 'invokes doGetSiteJournalInfo SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_deals_info, session_id: 1234).and_return(
          {do_get_site_journal_deals_info_response: {site_journal_deals_info: {deal_events_count: 0, deal_last_event_time: 0}}})
        session.count_deal_events
      end
    end

    context 'with starting point' do
      it 'invokes doGetSiteJournalInfo SOAP request' do
        expect(client).to receive(:call).with(:do_get_site_journal_deals_info, session_id: 1234,
          journal_start: 4321).and_return(
            {do_get_site_journal_deals_info_response: {site_journal_deals_info: {deal_events_count: 0, deal_last_event_time: 0}}})
        session.count_deal_events(4321)
      end
    end

    context 'on success' do
      let(:events_count) { session.count_deal_events }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_site_journal_deals_info_success'
      end

      it 'returns the number of events' do
        expect(events_count).to eq 5
      end
    end
  end

  describe '#for_each_deal_events_page' do
    let(:deal_events) do
      [ AllegroApi::DealEvent.new ] * 4
    end

    let(:in_block_code) { double }

    before do
      allow(session).to receive(:count_deal_events).and_return(8)
      allow(session).to receive(:get_deal_events).and_return(deal_events)
    end

    it 'performs code of the block for each page of events' do
      expect(in_block_code).to receive(:call).with(deal_events).twice
      session.for_each_deal_events_page {|page| in_block_code.call(page) }
    end
  end

  describe '#get_tranactions' do
    it 'invokes doGetPostBuyFormsDataForSellers SOAP request' do
      expect(client).to receive(:call).with(:do_get_post_buy_forms_data_for_sellers, session_id: 1234,
      transactions_ids_array: [{:item=>1}, {:item=>2}, {:item=>3}]).and_return({do_get_post_buy_forms_data_for_sellers_response: {post_buy_form_data: {}}})
      session.get_transactions([1,2,3])
    end

    context 'on success' do
      subject { session.get_transactions([1,2,3]) }

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
