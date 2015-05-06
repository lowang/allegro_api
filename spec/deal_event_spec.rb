describe AllegroApi::DealEvent do
  describe 'from_api' do
    let(:api_data) do
      {
        deal_event_id: 4556899786,
        deal_event_type: 2,
        deal_event_time: 1310432400,
        deal_id: 1269603383,
        deal_transaction_id: 1234,
        deal_seller_id: 4109848,
        deal_item_id: 1635208744,
        deal_buyer_id: 3301720,
        deal_quantity: 2
      }
    end

    subject { AllegroApi::DealEvent.from_api(api_data) }

    it 'sets id' do
      expect(subject.id).to eq 4556899786
    end

    it 'sets type of the event' do
      expect(subject.event_type).to eq 2
    end

    it 'sets created at' do
      expect(subject.created_at).to eq Time.at(1310432400)
    end

    it 'sets transaction id' do
      expect(subject.transaction_id).to eq 1234
    end

    it 'sets seller id' do
      expect(subject.seller_id).to eq 4109848
    end

    it 'sets item id' do
      expect(subject.item_id).to eq 1635208744
    end

    it 'sets buyer id' do
      expect(subject.buyer_id).to eq 3301720
    end

    it 'sets quantity' do
      expect(subject.quantity).to eq 2
    end
  end

  describe '#deal_created?' do
    it 'is true for deal event of type 1' do
      subject.event_type = 1
      expect(subject.deal_created?).to be_truthy
    end

    it 'is false for events with types other than 1' do
      expect(subject.deal_created?).to be_falsy
    end
  end

  describe '#transaction_created?' do
    it 'is true for deal event of type 2' do
      subject.event_type = 2
      expect(subject.transaction_created?).to be_truthy
    end

    it 'is false for events with types other than 2' do
      subject.event_type = 3
      expect(subject.transaction_created?).to be_falsy
    end
  end

  describe '#transaction_canceled?' do
    it 'is true for deal event of type 3' do
      subject.event_type = 3
      expect(subject.transaction_canceled?).to be_truthy
    end

    it 'is false for events with types other than 2' do
      expect(subject.transaction_canceled?).to be_falsy
    end
  end

  describe '#transaction_paid?' do
    it 'is true for deal event of type 4' do
      subject.event_type = 4
      expect(subject.transaction_paid?).to be_truthy
    end

    it 'is false for events with types other than 4' do
      expect(subject.transaction_paid?).to be_falsy
    end
  end
end
