describe AllegroApi::JournalEvent do
  describe 'from_api' do
    let(:api_data) do
      {
        row_id: 2869399784,
        item_id: 975967833,
        change_type: 'start',
        change_date: 1269603383,
        current_price: 0,
        item_seller_id: 4109848
      }
    end

    subject { AllegroApi::JournalEvent.from_api(api_data) }

    it 'sets event id' do
      expect(subject.id).to eq 2869399784
    end

    it 'sets item id' do
      expect(subject.item_id).to eq 975967833
    end

    it 'sets change type for event' do
      expect(subject.change_type).to eq 'start'
    end

    it 'sets changed at for event' do
      expect(subject.changed_at).to eq Time.at(1269603383)
    end

    it 'sets current price' do
      expect(subject.current_price).to eq 0
    end

    it 'sets seller id' do
      expect(subject.seller_id).to eq 4109848
    end
  end

  describe '#buy_now?' do
    let(:event) { AllegroApi::JournalEvent.new }

    it 'is true for "now" type events' do
      event.change_type = 'now'
      expect(event.buy_now?).to eq true
    end

    it 'is false for not "now" type events' do
      event.change_type = 'end'
      expect(event.buy_now?).to eq false
    end
  end

  describe '#auction_ended?' do
    let(:event) { AllegroApi::JournalEvent.new }

    it 'is true for "end" type events' do
      event.change_type = 'end'
      expect(event.auction_ended?).to eq true
    end

    it 'is false for not "end" type events' do
      event.change_type = 'now'
      expect(event.auction_ended?).to eq false
    end
  end
end
