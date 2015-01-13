describe AllegroApi::Item do
  describe 'from_api' do
    let(:api_data) do
      {
        item_id: "4762577271",
        item_title: "inny test",
        item_thumbnail_url: "http://example.com/thumbnail",
        item_price: {item: {price_type: "1",
        price_value: "5.55"}},
        item_start_quantity: "4",
        item_sold_quantity: "3",
        item_quantity_type: "2",
        item_start_time: "1420216922",
        item_end_time: "1421080922",
        item_end_time_left: "9 dni",
        item_bidders_counter: "5",
        item_highest_bidder: {user_id: "0",
        user_login: nil,
        user_rating: "0",
        user_icons: "0",
        user_country: "0"},
        item_category_id: "101360",
        item_watchers_counter: "6",
        item_views_counter: "11",
        item_note: "notatka",
        item_special_info: "0",
        item_shop_info: "0",
        item_product_info: "0",
        item_payu_info: "0",
        item_duration_info: {duration_type: "1"}
      }
    end

    let(:item) { AllegroApi::Item.from_api(api_data) }


    it "instantiates item" do
      expect(item).to be_instance_of(AllegroApi::Item)
    end

    it 'sets the id' do
      expect(item.id).to eq 4762577271
    end

    it 'sets title' do
      expect(item.title).to eq "inny test"
    end

    it 'sets thumbnail url' do
      expect(item.thumbnail_url).to eq "http://example.com/thumbnail"
    end

    it 'sets the price' do
      expect(item.price).to eq 5.55
    end

    it 'sets start quantity' do
      expect(item.start_quantity).to eq 4
    end

    it 'sets sold quantity' do
      expect(item.sold_quantity).to eq 3
    end

    it 'sets starts at' do
      expect(item.starts_at).to eq Time.at(1420216922)
    end

    it 'sets ends at' do
      expect(item.ends_at).to eq Time.at(1421080922)
    end

    it 'sets bidders count' do
      expect(item.bidders_count).to eq 5
    end

    it 'sets watchers count' do
      expect(item.watchers_count).to eq 6
    end

    it 'sets views count' do
      expect(item.views_count).to eq 11
    end

    it 'sets category id' do
      expect(item.category_id).to eq 101360
    end
  end
end