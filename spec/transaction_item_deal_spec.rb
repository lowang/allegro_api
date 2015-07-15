describe AllegroApi::TransactionItemDeal do
  describe 'from_api' do
    let(:api_data) do
      {
        deal_id: "987121979",
        deal_final_price: "20.00",
        deal_quantity: "1",
        deal_date: DateTime.new(2015,2,3,4,5,6),
        deal_was_discounted: true
      }
    end

    subject { AllegroApi::TransactionItemDeal.from_api(api_data) }

    it 'sets id' do
      expect(subject.id).to eq 987121979
    end

    it 'sets the price' do
      expect(subject.price).to eq 20.00
    end

    it 'sets when the deal was created at' do
      expect(subject.created_at).to eq DateTime.new(2015,2,3,4,5,6)
    end

    it 'sets if the deal was discounted' do
      expect(subject).to be_discounted
    end
  end
end
