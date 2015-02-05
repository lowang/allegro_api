describe AllegroApi::Image do
  let(:image_data) { File.binread(File.expand_path('../fixtures/image.jpg', __FILE__))}
  let(:api_data) { Base64.encode64(Base64.encode64(image_data))}
  let(:image) { AllegroApi::Image.new(data: image_data) }

  it 'has data' do
    expect(image).to respond_to(:data=, :data)
  end

  it 'can be converted to api data (base64 encoded string)' do
    expect(image.to_api).to eq api_data
  end

  describe 'from_api' do
    let(:api_image) { AllegroApi::Image.from_api(api_data) }

    it 'is an image' do
      expect(api_image).to be_instance_of(AllegroApi::Image)
    end

    it 'has data set' do
      expect(api_image.data).to eq image_data
    end
  end
end