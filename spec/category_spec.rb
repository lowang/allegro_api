describe AllegroApi::Category do
  let(:category) { AllegroApi::Category.new }

  it 'has an id' do
    expect(category).to respond_to(:id, :id=)
  end

  it 'has name' do
    expect(category).to respond_to(:name, :name=)
  end

  it 'has parent id' do
    expect(category).to respond_to(:parent_id, :parent_id=)
  end

  describe 'from_api' do
    let(:api_data) do
      { cat_id: "26013",
        cat_name: "Antyki i Sztuka",
        cat_parent: "6",
        cat_position: "69",
        cat_is_product_catalogue_enabled: "0"
      }
    end

    let(:category) { AllegroApi::Category.from_api(api_data) }

    it 'instantiates category' do
      expect(category).to be_instance_of AllegroApi::Category
    end

    it 'sets id' do
      expect(category.id).to eq 26013
    end

    it 'sets name' do
      expect(category.name).to eq "Antyki i Sztuka"
    end

    it 'sets parent id' do
      expect(category.parent_id).to eq 6
    end

    it 'sets position' do
      expect(category.position).to eq 69
    end
  end
end