require_relative './test_cache'

describe AllegroApi::Auction do
  let(:auction) { AllegroApi::Auction.new }

  it 'has fields' do
    expect(auction).to respond_to(:fields)
  end

  it 'initializes fields with empty hash' do
    expect(auction.fields).to be_instance_of(Hash)
    expect(auction.fields).to be_empty
  end

  describe 'from_api' do
    let(:data) do
      [
        { fid: "1",
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
        { :fid => "2",
          :fvalue_string => nil,
          :fvalue_int => "76652",
          :fvalue_float => "0",
          :fvalue_image => nil,
          :fvalue_datetime => "0",
          :fvalue_date => nil,
          :fvalue_range_int => {:fvalue_range_int_min => "0",
          :fvalue_range_int_max => "0"},
          :fvalue_range_float => {:fvalue_range_float_min => "0",
          :fvalue_range_float_max => "0"},
          :fvalue_range_date => {:fvalue_range_date_min => nil,
          :fvalue_range_date_max => nil} }
      ]
    end

    let(:auction) { AllegroApi::Auction.from_api(data) }

    before :each do
      AllegroApi.cache = TestCache.new
      AllegroApi.cache.store(:fields, 1, AllegroApi::Field.new(value_type: :string))
      AllegroApi.cache.store(:fields, 2, AllegroApi::Field.new(value_type: :integer))
    end

    after :each do
      AllegroApi.cache = nil
    end

    it 'instantiates Auction' do
      expect(auction).to be_instance_of(AllegroApi::Auction)
    end

    it 'sets the values for the fields of the auction' do
      expect(auction.fields.size).to eq 2
      expect(auction.fields[1]).to eq "nazwa aukcji"
      expect(auction.fields[2]).to eq 76652
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
    end

    it 'returns array' do
      expect(auction.to_api).to be_instance_of Array
    end

    it 'transforms each field to api data' do
      expect(auction.to_api.size).to eq 8
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
  end
end