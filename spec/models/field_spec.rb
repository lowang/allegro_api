require_relative '../test_cache'

describe AllegroApi::Field do
  let(:field) { AllegroApi::Field.new }

  it 'has an id' do
    expect(field).to respond_to(:id, :id=)
  end

  it 'has a title' do
    expect(field).to respond_to(:title, :title=)
  end

  it 'has type' do
    expect(field).to respond_to(:field_type, :field_type=)
  end


  describe 'range_field?' do
    describe 'for range options field (8)' do
      before :each do
        field.options = 8
      end

      it 'is true' do
        expect(field.range_field?).to eq true
      end
    end

    describe 'for not range options field' do
      before :each do
        field.options = 0
      end

      it 'is false' do
        expect(field.range_field?).to eq false
      end
    end
  end

  describe 'from_api' do
    describe 'for string type field' do
      let(:api_data) do
        { sell_form_id: "1",
          sell_form_title: "Nazwa przedmiotu",
          sell_form_cat: "0",
          sell_form_type: "1",
          sell_form_res_type: "1",
          sell_form_def_value: "domyślna wartość",
          sell_form_opt: "1",
          sell_form_pos: "0",
          sell_form_length: "50",
          sell_min_value: "0.00",
          sell_max_value: "0.00",
          sell_form_desc: nil,
          sell_form_opts_values: nil,
          sell_form_field_desc: "opis pola",
          sell_form_param_id: "0",
          sell_form_param_values: nil,
          sell_form_parent_id: "0",
          sell_form_parent_value: nil,
          sell_form_unit: "cm",
          sell_form_options: "8" }
      end

      let(:field) { AllegroApi::Field.from_api(api_data) }


      it 'instantiates field' do
        expect(field).to be_instance_of AllegroApi::Field
      end

      it 'sets id' do
        expect(field.id).to eq 1
      end

      it 'sets title' do
        expect(field.title).to eq 'Nazwa przedmiotu'
      end

      it 'sets category' do
        expect(field.category_id).to eq 0
      end

      it 'sets type' do
        expect(field.field_type).to eq :string
      end

      it 'sets value type' do
        expect(field.value_type).to eq :string
      end

      it 'sets required' do
        expect(field.required).to eq true
      end

      it 'sets max length' do
        expect(field.max_length).to eq 50
      end

      it 'sets default value' do
        expect(field.default_value).to eq 'domyślna wartość'
      end

      it 'sets options' do
        expect(field.options).to eq 8
      end

      it 'sets unit' do
        expect(field.unit).to eq 'cm'
      end

      it 'sets description' do
        expect(field.description).to eq 'opis pola'
      end
    end

    describe 'for numeric field (integer, float) field' do
      let(:api_data) do
        { sell_form_id: "2",
          sell_form_title: "Kategoria",
          sell_form_cat: "0",
          sell_form_type: "2",
          sell_form_res_type: "2",
          sell_form_def_value: "0",
          sell_form_opt: "1",
          sell_form_pos: "2",
          sell_form_length: "500",
          sell_min_value: "1.5",
          sell_max_value: "9.5",
          sell_form_desc: nil,
          sell_form_opts_values: nil,
          sell_form_field_desc: "Dokładnie określ kategorię przedmiotu",
          sell_form_param_id: "0",
          sell_form_param_values: nil,
          sell_form_parent_id: "0",
          sell_form_parent_value: nil,
          sell_form_unit: nil,
          sell_form_options: "0" }
      end

      let(:field) { AllegroApi::Field.from_api(api_data) }

      it 'sets type' do
        expect(field.field_type).to eq :integer
      end

      it 'sets min value if present' do
        expect(field.min_value).to eq 1.5
      end

      it 'does not set min value if not present' do
        api_data[:sell_min_value] = '0.00'
        expect(field.min_value).to be_nil
      end

      it 'sets max value if present' do
        expect(field.max_value).to eq 9.5
      end

      it 'does not set max value if not present' do
        api_data[:sell_max_value] = '0.00'
        expect(field.max_value).to be_nil
      end
    end

    describe 'for combobox field' do
      let(:api_data) do
        { sell_form_id: "4",
          sell_form_title: "Czas trwania",
          sell_form_cat: "0",
          sell_form_type: "4",
          sell_form_res_type: "2",
          sell_form_def_value: "2",
          sell_form_opt: "1",
          sell_form_pos: "0",
          sell_form_length: "2",
          sell_min_value: "0.00",
          sell_max_value: "99.00",
          sell_form_desc: "3|5|7|Do wyczerpania",
          sell_form_opts_values: "0|1|2|99",
          sell_form_field_desc: "\"Przy wystawieniu na 14 dni - pobierana jest opłata 0,20 zł",
          sell_form_param_id: "0",
          sell_form_param_values: nil,
          sell_form_parent_id: "0",
          sell_form_parent_value: nil,
          sell_form_unit: nil,
          sell_form_options: "0" }
      end

      let(:field) { AllegroApi::Field.from_api(api_data) }

      it 'sets field value set' do
        expect(field.value_set).to match({0 => '3', 1 => '5', 2 => '7', 99 => 'Do wyczerpania'})
      end
    end
  end

  describe 'find' do
    let(:field) { double }

    before :each do
      AllegroApi.cache = TestCache.new
    end

    after :each do
      AllegroApi.cache = nil
    end

    it 'attempts to fetch field from local cache' do
      expect(AllegroApi.cache).to receive(:fetch).with(:fields, 1).and_return(field)
      AllegroApi::Field.find 1
    end

    it 'raises unknown field exception if field not found' do
      allow(AllegroApi.cache).to receive(:fetch).and_return(nil)
      expect {AllegroApi::Field.find 1}.to raise_error AllegroApi::UnknownField
    end
  end

  describe '#value_from_api' do
    let(:image_data) { File.binread(File.join(AllegroApi.root,'spec/fixtures/image.jpg')) }
    let(:api_image_data) { Base64.encode64(Base64.encode64(image_data)) }

    let(:api_data) do
      { fid: "1",
        fvalue_string: "string value",
        fvalue_int: "1",
        fvalue_float: "2.54",
        fvalue_image: api_image_data,
        fvalue_datetime: "1419260065",
        fvalue_date: '23-12-2014',
        fvalue_range_int: {fvalue_range_int_min: "0",
          fvalue_range_int_max: "5"},
        fvalue_range_float: {fvalue_range_float_min: "2.3",
          fvalue_range_float_max: "4.5"},
        fvalue_range_date: {fvalue_range_date_min: '01-12-2014',
        fvalue_range_date_max: '31-12-2014'} }
    end

    describe 'for image type field' do
      let(:field) { AllegroApi::Field.new value_type: :image }

      it 'creates image' do
        expect(field.value_from_api(api_data)).to be_instance_of AllegroApi::Image
      end
    end

    describe 'for string type field' do
      let(:field) { AllegroApi::Field.new value_type: :string }

      it 'uses fvalue_string' do
        expect(field.value_from_api(api_data)).to eq 'string value'
      end
    end

    describe 'for integer type field' do
      let(:field) { AllegroApi::Field.new value_type: :integer }

      it 'uses fvalue_int' do
        expect(field.value_from_api(api_data)).to eq 1
      end
    end

    describe 'for float type field' do
      let(:field) { AllegroApi::Field.new value_type: :float }

      it 'uses fvalue_float' do
        expect(field.value_from_api(api_data)).to eq 2.54
      end
    end

    describe 'for datetime type field' do
      let(:field) { AllegroApi::Field.new value_type: :datetime }

      it 'uses fvalue_datetime' do
        expect(field.value_from_api(api_data)).to eq Time.at(1419260065)
      end
    end

    describe 'for date type field' do
      let(:field) { AllegroApi::Field.new value_type: :date }

      it 'uses fvalue_date' do
        expect(field.value_from_api(api_data)).to eq Date.strptime('23-12-2014', '%d-%m-%Y')
      end
    end

    describe 'for range integer field' do
      let(:field) { AllegroApi::Field.new options: 8, value_type: :integer}

      it 'uses fvalue_range_int values' do
        expect(field.value_from_api(api_data)).to eq 0..5
      end
    end

    describe 'for range date field' do
      let(:field) { AllegroApi::Field.new options: 8, value_type: :date}

      it 'uses fvalue_range_date values' do
        expect(field.value_from_api(api_data)).to eq Date.strptime('01-12-2014', '%d-%m-%Y')..Date.strptime('31-12-2014', '%d-%m-%Y')
      end
    end

    describe 'for date type field' do
      let(:field) { AllegroApi::Field.new value_type: :date }

      it 'uses fvalue_date' do
        expect(field.value_from_api(api_data)).to eq Date.strptime('23-12-2014', '%d-%m-%Y')
      end
    end
  end
end
