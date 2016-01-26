describe AllegroApi::TransactionAddress do
  describe 'from_api' do
    let(:api_data) do
      {
        post_buy_form_adr_country: "1",
        post_buy_form_adr_street: 'ul. Gen. Maczka 1A/4',
        post_buy_form_adr_postcode: '60-651',
        post_buy_form_adr_city: 'Poznań',
        post_buy_form_adr_full_name: 'DHL SERVICE POINT: moto-obroty',
        post_buy_form_adr_company: 'DHL',
        post_buy_form_adr_phone: '600111222',
        post_buy_form_adr_nip: '12345',
        post_buy_form_created_date: DateTime.new(2015,2,3,4,5,6),
        post_buy_form_adr_type: "0"
      }
    end

    subject { AllegroApi::TransactionAddress.from_api(api_data) }

    it 'sets country' do
      expect(subject.country).to eq 1
    end

    it 'sets street' do
      expect(subject.street).to eq 'ul. Gen. Maczka 1A/4'
    end

    it 'sets zipcode' do
      expect(subject.zipcode).to eq '60-651'
    end

    it 'sets city' do
      expect(subject.city).to eq 'Poznań'
    end

    it 'sets full name' do
      expect(subject.full_name).to eq 'DHL SERVICE POINT: moto-obroty'
    end

    it 'sets company' do
      expect(subject.company).to eq 'DHL'
    end

    it 'sets phone' do
      expect(subject.phone).to eq '600111222'
    end

    it 'sets nip' do
      expect(subject.nip).to eq '12345'
    end

    it 'sets created at' do
      expect(subject.created_at).to eq DateTime.new(2015,2,3,4,5,6)
    end

    it 'sets address type' do
      expect(subject.address_type).to eq 0
    end
  end
end
