require_relative './test_cache'

describe AllegroApi::Auction do
  let(:auction) { AllegroApi::Auction.new }

  let(:image_data) { File.binread(File.expand_path('../fixtures/image.jpg', __FILE__))}
  let(:api_image_data) { Base64.encode64(Base64.encode64(image_data))}

  it 'has fields' do
    expect(auction).to respond_to(:fields)
  end

  it 'has photos' do
    expect(auction).to respond_to(:photos)
  end

  it 'has an id' do
    expect(auction).to respond_to(:id=, :id)
  end

  it 'initializes fields with empty hash' do
    expect(auction.fields).to be_instance_of(Hash)
    expect(auction.fields).to be_empty
  end

  it 'initializes photos with empty array' do
    expect(auction.photos).to be_instance_of(Array)
    expect(auction.photos).to be_empty
  end

  describe '#name' do
    it 'returns value of the NAME field' do
      auction.fields[AllegroApi::Fid::NAME] = 'some auction'
      expect(auction.name).to eq 'some auction'
    end
  end

  describe '#name=' do
    it 'sets value of the NAME field' do
      auction.name = 'some auction'
      expect(auction.fields[AllegroApi::Fid::NAME]).to eq 'some auction'
    end
  end

  describe '#category_id' do
    it 'returns value of the CATEGORY field' do
      auction.fields[AllegroApi::Fid::CATEGORY] = 11
      expect(auction.category_id).to eq 11
    end
  end

  describe '#category_id=' do
    it 'sets value of the CATEGORY field' do
      auction.category_id = 12
      expect(auction.fields[AllegroApi::Fid::CATEGORY]).to eq 12
    end
  end

  describe '#duration' do
    it 'returns value of the DURATION field' do
      auction.fields[AllegroApi::Fid::DURATION] = 11
      expect(auction.duration).to eq 11
    end
  end

  describe '#duration=' do
    it 'sets value of the DURATION field' do
      auction.duration = 12
      expect(auction.fields[AllegroApi::Fid::DURATION]).to eq 12
    end
  end

  describe '#quantity' do
    it 'returns value of the QUANTITY field' do
      auction.fields[AllegroApi::Fid::QUANTITY] = 11
      expect(auction.quantity).to eq 11
    end
  end

  describe '#quantity=' do
    it 'sets value of the QUANTITY field' do
      auction.quantity = 12
      expect(auction.fields[AllegroApi::Fid::QUANTITY]).to eq 12
    end
  end

  describe '#quantity_type' do
    it 'returns value of the QUANTITY_TYPE field' do
      auction.fields[AllegroApi::Fid::QUANTITY_TYPE] = 1
      expect(auction.quantity_type).to eq 1
    end
  end

  describe '#quantity_type=' do
    it 'sets value of the QUANTITY_TYPE field' do
      auction.quantity_type = 2
      expect(auction.fields[AllegroApi::Fid::QUANTITY_TYPE]).to eq 2
    end
  end

  describe '#promo_options' do
    it 'returns value of the PROMO_OPTIONS field' do
      auction.fields[AllegroApi::Fid::PROMO_OPTIONS] = 1
      expect(auction.promo_options).to eq 1
    end
  end

  describe '#promo_options=' do
    it 'sets value of the PROMO_OPTIONS field' do
      auction.promo_options = 2
      expect(auction.fields[AllegroApi::Fid::PROMO_OPTIONS]).to eq 2
    end
  end

  describe '#price' do
    it 'returns value of the BUY_NOW_PRICE field' do
      auction.fields[AllegroApi::Fid::BUY_NOW_PRICE] = 6.69
      expect(auction.price).to eq 6.69
    end
  end

  describe '#price=' do
    it 'sets value of the BUY_NOW_PRICE field' do
      auction.price = 7.72
      expect(auction.fields[AllegroApi::Fid::BUY_NOW_PRICE]).to eq 7.72
    end
  end

  describe '#country' do
    it 'returns value of the COUNTRY field' do
      auction.fields[AllegroApi::Fid::COUNTRY] = 1
      expect(auction.country).to eq 1
    end
  end

  describe '#country=' do
    it 'sets value of the COUNTRY field' do
      auction.country = 2
      expect(auction.fields[AllegroApi::Fid::COUNTRY]).to eq 2
    end
  end

  describe '#city' do
    it 'returns value of the CITY field' do
      auction.fields[AllegroApi::Fid::CITY] = 'Gdynia'
      expect(auction.city).to eq 'Gdynia'
    end
  end

  describe '#city=' do
    it 'sets value of the CITY field' do
      auction.city = 'Gdańsk'
      expect(auction.fields[AllegroApi::Fid::CITY]).to eq 'Gdańsk'
    end
  end

  describe '#info' do
    it 'returns value of the INFO field' do
      auction.fields[AllegroApi::Fid::INFO] = 'product description'
      expect(auction.info).to eq 'product description'
    end
  end

  describe '#info=' do
    it 'sets value of the INFO field' do
      auction.info = 'product info'
      expect(auction.fields[AllegroApi::Fid::INFO]).to eq 'product info'
    end
  end

  describe '#zipcode' do
    it 'returns value of the ZIPCODE field' do
      auction.fields[AllegroApi::Fid::ZIPCODE] = '80-800'
      expect(auction.zipcode).to eq '80-800'
    end
  end

  describe '#zipcode=' do
    it 'sets value of the ZIPCODE field' do
      auction.zipcode = '80-800'
      expect(auction.fields[AllegroApi::Fid::ZIPCODE]).to eq '80-800'
    end
  end

  describe '#province' do
    it 'returns value of the PROVINCE field' do
      auction.fields[AllegroApi::Fid::PROVINCE] = 1
      expect(auction.province).to eq 1
    end
  end

  describe '#province=' do
    it 'sets value of the PROVINCE field' do
      auction.province = 2
      expect(auction.fields[AllegroApi::Fid::PROVINCE]).to eq 2
    end
  end

  describe '#bank_account' do
    it 'returns value of the BANK_ACCOUNT_1 field' do
      auction.fields[AllegroApi::Fid::BANK_ACCOUNT_1] = '123455'
      expect(auction.bank_account).to eq '123455'
    end
  end

  describe '#bank_account=' do
    it 'sets value of the BANK_ACCOUNT_1 field' do
      auction.bank_account = '543211'
      expect(auction.fields[AllegroApi::Fid::BANK_ACCOUNT_1]).to eq '543211'
    end
  end

  describe 'from_api' do
    let(:data) do
      [
        { fid: AllegroApi::Fid::NAME.to_s,
          fvalue_string: "nazwa aukcji",
          fvalue_int: "0",
          fvalue_float: "0",
          fvalue_image: '',
          fvalue_datetime: "0",
          fvalue_date: nil,
          fvalue_range_int: {fvalue_range_int_min: "0",
            fvalue_range_int_max: "0"},
          fvalue_range_float: {fvalue_range_float_min: "0",
            fvalue_range_float_max: "0"},
          fvalue_range_date: {fvalue_range_date_min: nil,
          fvalue_range_date_max: nil} },
        { fid: AllegroApi::Fid::CATEGORY.to_s,
          fvalue_string: nil,
          fvalue_int: "76652",
          fvalue_float: "0",
          fvalue_image: nil,
          fvalue_datetime: "0",
          fvalue_date: nil,
          fvalue_range_int: {fvalue_range_int_min: "0",
          fvalue_range_int_max: "0"},
          fvalue_range_float: {fvalue_range_float_min: "0",
          fvalue_range_float_max: "0"},
          fvalue_range_date: {fvalue_range_date_min: nil,
          fvalue_range_date_max: nil} },
        { fid: AllegroApi::Fid::PHOTO1.to_s,
          fvalue_string: nil,
          fvalue_int: "0",
          fvalue_float: "0",
          fvalue_image: api_image_data,
          fvalue_datetime: "0",
          fvalue_date: nil,
          fvalue_range_int: {fvalue_range_int_min: "0",
          fvalue_range_int_max: "0"},
          fvalue_range_float: {fvalue_range_float_min: "0",
          fvalue_range_float_max: "0"},
          fvalue_range_date: {fvalue_range_date_min: nil,
          fvalue_range_date_max: nil} }
      ]
    end

    let(:auction) { AllegroApi::Auction.from_api(data) }

    before :each do
      AllegroApi.cache = TestCache.new
      AllegroApi.cache.store(:fields, AllegroApi::Fid::NAME, AllegroApi::Field.new(value_type: :string))
      AllegroApi.cache.store(:fields, AllegroApi::Fid::CATEGORY, AllegroApi::Field.new(value_type: :integer))
      AllegroApi.cache.store(:fields, AllegroApi::Fid::PHOTO1, AllegroApi::Field.new(value_type: :image))
    end

    after :each do
      AllegroApi.cache = nil
    end

    it 'instantiates Auction' do
      expect(auction).to be_instance_of(AllegroApi::Auction)
    end

    it 'sets the values for the fields of the auction' do
      expect(auction.fields.size).to eq 2
      expect(auction.fields[AllegroApi::Fid::NAME]).to eq "nazwa aukcji"
      expect(auction.fields[AllegroApi::Fid::CATEGORY]).to eq 76652
    end

    it 'populates photos' do
      expect(auction.photos.size).to eq 1
      expect(auction.photos.first.data).to eq image_data
    end
  end

  describe 'to_api' do
    let(:auction) { AllegroApi::Auction.new }

    before :each do
      auction.fields[1] = 1
      auction.fields[2] = 2.3
      auction.fields[3] = 'test'
      auction.fields[4] = Date.new 2014,12,23
      auction.fields[5] = Time.at 1419346207
      auction.fields[6] = 1..10
      auction.fields[7] = 2.5..6.9
      auction.fields[8] = Date.new(2014,01,01)..Date.new(2014,12,31)
      auction.fields[9] = BigDecimal.new "6.66"
      auction.photos << AllegroApi::Image.new(data: image_data)
    end

    it 'returns array' do
      expect(auction.to_api).to be_instance_of Array
    end

    it 'transforms each field to api data' do
      expect(auction.to_api.size).to eq 10
    end

    it 'transforms integer values' do
      expect(auction.to_api[0]).to eq({ fid: 1,
        fvalue_string: "",
        fvalue_int: 1,
        fvalue_float: 0,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end

    it 'transforms float values' do
      expect(auction.to_api[1]).to eq({ fid: 2,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 2.3,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end

    it 'transforms string values' do
      expect(auction.to_api[2]).to eq({ fid: 3,
        fvalue_string: "test",
        fvalue_int: 0,
        fvalue_float: 0,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end

    it 'transforms date values' do
      expect(auction.to_api[3]).to eq({ fid: 4,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 0,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '23-12-2014',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end

    it 'transforms time values' do
      expect(auction.to_api[4]).to eq({ fid: 5,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 0,
        fvalue_image: '',
        fvalue_datetime: 1419346207,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end

    it 'transforms integer range values' do
      expect(auction.to_api[5]).to eq({ fid: 6,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 0,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 1,
          fvalue_range_int_max: 10},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end

    it 'transforms float range values' do
      expect(auction.to_api[6]).to eq({ fid: 7,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 0,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 2.5,
          fvalue_range_float_max: 6.9},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end

    it 'transforms date range values' do
      expect(auction.to_api[7]).to eq({ fid: 8,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 0,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '01-01-2014',
        fvalue_range_date_max: '31-12-2014'} })
    end

    it 'transforms BigDecimal values' do
      expect(auction.to_api[8]).to eq({ fid: 9,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 6.66,
        fvalue_image: '',
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end

    it 'transforms image values' do
      expect(auction.to_api[9]).to eq({ fid: AllegroApi::Fid::PHOTO1,
        fvalue_string: "",
        fvalue_int: 0,
        fvalue_float: 0,
        fvalue_image: api_image_data,
        fvalue_datetime: 0,
        fvalue_date: '',
        fvalue_range_int: {fvalue_range_int_min: 0,
          fvalue_range_int_max: 0},
        fvalue_range_float: {fvalue_range_float_min: 0,
          fvalue_range_float_max: 0},
        fvalue_range_date: {fvalue_range_date_min: '',
        fvalue_range_date_max: ''} })
    end
  end
end