require_relative '../spec_helper'

describe AllegroApi::State do
  describe 'find_by_id' do
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
    describe '99' do
      subject { AllegroApi::State.find_by_id(state_id) }
      it { is_expected.to be_nil }
    end
  end
  describe 'find_by_name' do
    let(:state_name) { self.class.metadata[:description] }
    subject { AllegroApi::State.find_by_name(state_name) }
    describe 'Kujawsko-pomorskie' do
      it { is_expected.to have_attributes(id: 2) }
    end
    describe 'pacanowskie' do
      it { is_expected.to be_nil }
    end
  end
end
