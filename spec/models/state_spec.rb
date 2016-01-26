require_relative '../spec_helper'

describe AllegroApi::State do
  let(:state_id) { self.class.metadata[:description].to_i }
  subject { AllegroApi::State.find_by_id(state_id).name }

  describe '1' do
    it { is_expected.to eq('dolnośląskie') }
  end
  describe '2' do
    it { is_expected.to eq('kujawsko-pomorskie') }
  end
  describe '16' do
    it { is_expected.to eq('zachodniopomorskie') }
    it 'has id' do
      expect(AllegroApi::State.find_by_id(state_id).id).to eq(state_id)
    end
  end
end
