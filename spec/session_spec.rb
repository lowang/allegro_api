require_relative './test_cache'

describe AllegroApi::Session do
  let(:session_id) { 1234 }
  let(:user_id) { 5 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }

  let(:client) { AllegroApi::Client.new wsdl: wsdl_url }
  let(:session) { AllegroApi::Session.new(client, session_id, user_id) }

  it 'provides session id' do
    expect(session.id).to eq session_id
  end

  it 'provides user id' do
    expect(session.user_id).to eq user_id
  end

  describe '#get_sell_items' do
    it 'invokes doGetMySellItems SOAP request' do
      expect(client).to receive(:call).with(:do_get_my_sell_items,
        session_id: 1234).and_return(
          {do_get_my_sell_items_response: {sell_items_list: {item: []}}})
      session.get_sell_items
    end

    it 'respects list of items ids provided' do
      expect(client).to receive(:call).with(:do_get_my_sell_items,
        session_id: 1234, item_ids: {item: [1,2,3,4]}).and_return(
          {do_get_my_sell_items_response: {sell_items_list: {item: []}}})
      session.get_sell_items(1,2,3,4)
    end

    describe 'on success' do
      let(:items) { session.get_sell_items }

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

  describe '#get_sold_items' do
    it 'invokes doGetMySellItems SOAP request' do
      expect(client).to receive(:call).with(:do_get_my_sold_items,
        session_id: 1234).and_return(
          {do_get_my_sold_items_response: {sold_items_list: {item: []}}})
      session.get_sold_items
    end

    it 'respects list of items ids provided' do
      expect(client).to receive(:call).with(:do_get_my_sold_items,
        session_id: 1234, item_ids: {item: [1,2,3,4]}).and_return(
          {do_get_my_sold_items_response: {sold_items_list: {item: []}}})
      session.get_sold_items(1,2,3,4)
    end

    describe 'on success' do
      let(:items) { session.get_sold_items }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_my_sold_items_success'
      end

      it 'returns an array of items' do
        expect(items).to be_instance_of Array
        expect(items.size).to eq 2
        expect(items).to all(be_instance_of AllegroApi::Item)
      end
    end
  end

  describe '#get_not_sold_items' do
    it 'invokes doGetMySellItems SOAP request' do
      expect(client).to receive(:call).with(:do_get_my_not_sold_items,
        session_id: 1234).and_return(
          {do_get_my_not_sold_items_response: {not_sold_items_list: {item: []}}})
      session.get_not_sold_items
    end

    it 'respects list of items ids provided' do
      expect(client).to receive(:call).with(:do_get_my_not_sold_items,
        session_id: 1234, item_ids: {item: [1,2,3,4]}).and_return(
          {do_get_my_not_sold_items_response: {not_sold_items_list: {item: []}}})
          session.get_not_sold_items(1,2,3,4)
    end

    describe 'on success' do
      let(:items) { session.get_not_sold_items }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_my_not_sold_items_success'
      end

      it 'returns an array of items' do
        expect(items).to be_instance_of Array
        expect(items.size).to eq 2
        expect(items).to all(be_instance_of AllegroApi::Item)
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

    describe 'on success' do
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

    describe 'on success' do
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
end
