require 'spec_helper'
describe AllegroApi::Transaction do
  describe 'from_api' do
    let(:parsed_api_response) { Psych.load_file(File.join(AllegroApi.root, 'spec/fixtures/do_get_post_buy_forms_data_for_sellers.yml')) }

    it 'parses api response' do
      transaction = AllegroApi::Transaction.from_api(parsed_api_response)
      expect(transaction.id).to eq(431237130)
      expect(transaction.items.first.id).to eq(5119194000)
      expect(transaction.items.first.title).to eq("iphone 5s")
      expect(transaction.items.first.amount).to eq(BigDecimal.new("1899"))
      expect(transaction.items.first.deals.first.datetime).to eq(Time.at(1425646461).to_datetime)
      expect(transaction.items.first.deals.first.quantity).to eq(1)

      expect(transaction.buyer.id).to eq(413691)
      expect(transaction.buyer.login).to eq("januszzallegro")
      expect(transaction.buyer.email).to eq("janusz@buziaczek.pl")
      expect(transaction.shipment_address.full_name).to eq("Jan Kwiatkoski")
      expect(transaction.shipment_address.company).to eq("u Janusza")
      expect(transaction.shipment_address.country_id).to eq(1)
      expect(transaction.shipment_address.post_code).to eq("11-111")
      expect(transaction.shipment_address.city).to eq("Warszawa")
      expect(transaction.shipment_address.address).to eq("Marcelinskaya 90")
      expect(transaction.shipment_address.phone).to eq("+381111111111")
    end
  end
end
