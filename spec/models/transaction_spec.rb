require 'spec_helper'

describe AllegroApi::Transaction do
  describe 'from_api1' do
    let(:parsed_api_response) { Psych.load_file(File.join(AllegroApi.root, 'spec/fixtures/do_get_post_buy_forms_data_for_sellers.yml')) }

    it 'parses api response' do
      transaction = AllegroApi::Transaction.from_api(parsed_api_response)
      expect(transaction.id).to eq(431237130)
      expect(transaction.items.first.id).to eq(5119194000)
      expect(transaction.items.first.title).to eq("iphone 5s")
      expect(transaction.items.first.amount).to eq(BigDecimal.new("1899"))
      expect(transaction.items.first.deals.first.created_at).to eq(Time.at(1425646461).to_datetime)
      expect(transaction.items.first.deals.first.quantity).to eq(1)

      expect(transaction.buyer.id).to eq(413691)
      expect(transaction.buyer.login).to eq("januszzallegro")
      expect(transaction.buyer.email).to eq("janusz@buziaczek.pl")
      expect(transaction.shipment_address.full_name).to eq("Jan Kwiatkoski")
      expect(transaction.shipment_address.company).to eq("u Janusza")
      expect(transaction.shipment_address.country).to eq(1)
      expect(transaction.shipment_address.zipcode).to eq("11-111")
      expect(transaction.shipment_address.city).to eq("Warszawa")
      expect(transaction.shipment_address.street).to eq("Marcelinskaya 90")
      expect(transaction.shipment_address.phone).to eq("+381111111111")
    end
  end

  describe 'from_api2' do
    let(:api_data) do
      { post_buy_form_id: "3381748",
        post_buy_form_items: {
          item: {
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
                deal_date: DateTime.new(2015,2,3,4,5,6),
                deal_was_discounted: true
              }}
          }},
        post_buy_form_buyer_id: "2580451",
        post_buy_form_amount: "36.00",
        post_buy_form_postage_amount: "16.00",
        post_buy_form_invoice_option: "1",
        post_buy_form_msg_to_seller: 'Proszę o szybką wysyłkę',
        post_buy_form_invoice_data: {
          post_buy_form_adr_country: "0",
          post_buy_form_adr_street: '',
          post_buy_form_adr_postcode: '',
          post_buy_form_adr_city: '',
          post_buy_form_adr_full_name: '',
          post_buy_form_adr_company: '',
          post_buy_form_adr_phone: '',
          post_buy_form_adr_nip: '',
          post_buy_form_created_date: '',
          post_buy_form_adr_type: "0"
        },
        post_buy_form_shipment_address: {
          post_buy_form_adr_country: "1",
          post_buy_form_adr_street: 'ul. Wspólna 80',
          post_buy_form_adr_postcode: '60-328',
          post_buy_form_adr_city: 'Poznań',
          post_buy_form_adr_full_name: 'Jan Kowalski',
          post_buy_form_adr_company: '',
          post_buy_form_adr_phone: '987-654-321',
          post_buy_form_adr_nip: '',
          post_buy_form_created_date: DateTime.new(2015,2,3,4,5,6),
          post_buy_form_adr_type: "1"
        },
        post_buy_form_pay_type: 'ab',
        post_buy_form_pay_id: "67364906",
        post_buy_form_pay_status: 'Zakończona',
        post_buy_form_date_init: DateTime.new(2015,2,3,4,5,6),
        post_buy_form_date_recv: DateTime.new(2015,2,3,4,5,6),
        post_buy_form_date_cancel: '',
        post_buy_form_shipment_id: "10005",
        post_buy_form_gd_address: {
          post_buy_form_adr_country: "1",
          post_buy_form_adr_street: 'ul. Gen. Maczka 1A/4',
          post_buy_form_adr_postcode: '60-651',
          post_buy_form_adr_city: 'Poznań',
          post_buy_form_adr_full_name: 'DHL SERVICE POINT: moto-obroty',
          post_buy_form_adr_company: '',
          post_buy_form_adr_phone: '600111222',
          post_buy_form_adr_nip: '',
          post_buy_form_created_date: DateTime.new(2015,2,3,4,5,6),
          post_buy_form_adr_type: "0"
        },
        post_buy_form_shipment_tracking: [
          {
            post_buy_form_operator_id: "3",
            post_buy_form_package_id: '2812050417473',
            post_buy_form_package_status: 'Dostarczone',
          },
          {
            post_buy_form_operator_id: "1",
            post_buy_form_package_id: '1Z7E09X67746525354',
            post_buy_form_package_status: 'Wysłane z ładunkiem'
          }],
        post_buy_form_surcharges_list: ["4381748"],
        post_buy_form_gd_additional_info: 'W soboty punkt czynny do godziny 14.',
        post_buy_form_payment_amount: "40.00",
        post_buy_form_sent_by_seller: "0",
        post_buy_form_buyer_login: 'logintestowy',
        post_buy_form_buyer_email: 'test@domena.pl' }
    end

    subject { AllegroApi::Transaction.from_api(api_data) }

    it 'sets id' do
      expect(subject.id).to eq 3381748
    end

    it 'populates items' do
      expect(subject.items.size).to eq 1
      expect(subject.items).to all(be_instance_of AllegroApi::TransactionItem)
    end

    it 'sets message' do
      expect(subject.message).to eq 'Proszę o szybką wysyłkę'
    end

    it 'sets total amount' do
      expect(subject.total_amount).to eq 36.00
    end

    it 'sets shipment amount' do
      expect(subject.shipment_amount).to eq 16.00
    end

    it 'sets invoice required' do
      expect(subject.invoice_required).to eq true
    end

    it 'sets payment type' do
      expect(subject.payment.type).to eq 'ab'
    end

    it 'sets payment id' do
      expect(subject.payment.id).to eq 67364906
    end

    it 'sets payment status' do
      expect(subject.payment.status).to eq 'Zakończona'
    end

    it 'sets payment inititated at time' do
      expect(subject.payment.initiated_at).to eq DateTime.new(2015,2,3,4,5,6)
    end

    it 'sets payment received at time' do
      expect(subject.payment.received_at).to eq DateTime.new(2015,2,3,4,5,6)
    end

    it 'sets shipment method id' do
      expect(subject.shipment_method_id).to eq 10005
    end

    it 'sets invoice address' do
      expect(subject.invoice_address).to be_instance_of(AllegroApi::TransactionAddress)
    end

    it 'sets shipment address' do
      expect(subject.shipment_address).to be_instance_of(AllegroApi::TransactionAddress)
    end

    it 'sets delivery point address' do
      expect(subject.delivery_point_address).to be_instance_of(AllegroApi::TransactionAddress)
    end

    it 'sets buyer id' do
      expect(subject.buyer.id).to eq 2580451
    end

    it 'sets buyer login' do
      expect(subject.buyer.login).to eq 'logintestowy'
    end

    it 'sets buyer email' do
      expect(subject.buyer.email).to eq 'test@domena.pl'
    end
  end
end
