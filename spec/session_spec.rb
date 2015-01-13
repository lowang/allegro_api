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
          expect(auction.fields[2]).to eq 76652
        end

        it 'has name set' do
          expect(auction.fields[1]).to eq "niezwykły przedmiot"
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
end