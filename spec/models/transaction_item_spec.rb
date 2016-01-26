require 'spec_helper'

describe AllegroApi::TransactionItem do
  describe 'from_api' do
    let(:api_data) do
      {
        post_buy_form_it_quantity: "2",
        post_buy_form_it_amount: "20.00",
        post_buy_form_it_id: "972090662",
        post_buy_form_it_title: 'Oferta testowa',
        post_buy_form_it_country: "1",
        post_buy_form_it_price: "10.00",
        post_buy_form_it_deals: {
          item: {
            deal_id: "987121979",
            deal_final_price: "20.00",
            deal_quantity: "1",
            deal_date: '2013-12-18 13:08:16',
            deal_was_discounted: true
          }}
      }
    end

    subject { AllegroApi::TransactionItem.from_api(api_data) }

    it 'sets id' do
      expect(subject.id).to eq 972090662
    end

    it 'sets quantity' do
      expect(subject.quantity).to eq 2
    end

    it 'sets amount' do
      expect(subject.amount).to eq 20.00
    end

    it 'sets title' do
      expect(subject.title).to eq 'Oferta testowa'
    end

    it 'sets country' do
      expect(subject.country).to eq 1
    end

    it 'sets price' do
      expect(subject.price).to eq 10.00
    end

    it 'sets deals' do
      expect(subject.deals.size).to eq 1
      expect(subject.deals).to all(be_instance_of AllegroApi::TransactionItemDeal)
    end
  end
end
