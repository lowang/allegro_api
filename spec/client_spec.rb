describe AllegroApi::Client do
  let(:webapi_key) { '12345' }
  let(:country_code) { 99 }
  let(:wsdl_url) { 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl' }
  let(:api_version) { '54321' }
  let(:client) { AllegroApi::Client.new webapi_key: webapi_key, wsdl: wsdl_url, country_code: country_code, api_version: api_version }

  it 'allows to configure webapi key' do
    expect(client).to respond_to(:webapi_key=, :webapi_key)
  end

  it 'remebers webapi key' do
    client.webapi_key = 'api key'
    expect(client.webapi_key).to eq 'api key'
  end

  it 'allows configuring url for wsdl' do
    expect(client).to respond_to(:wsdl=, :wsdl)
  end

  it 'remebers wsdl url' do
    expect(client.wsdl).to eq wsdl_url
  end

  it 'allows to configure country_code' do
    expect(client).to respond_to(:country_code=, :country_code)
  end

  it 'defaults country code to 1 (poland)' do
    client = AllegroApi::Client.new
    expect(client.country_code).to eq 1
  end

  it 'remebers country code' do
    expect(client.country_code).to eq country_code
  end

  it 'provides soap client' do
    expect(client.soap_client).to be_instance_of Savon::Client
  end


  describe "#call" do
    let(:response) { double(body: {})}
    before :each do
      stub_wsdl_request_for wsdl_url
      allow(client.soap_client).to receive(:call).with(:api_method, message: api_method_params).and_return(response)
    end

    let(:api_method_params) { {login: 'login', password: 'password'} }

    it "forwards the call to soap client" do
      expect(client.soap_client).to receive(:call).with(:api_method, message: api_method_params).and_return(response)
      client.call :api_method, api_method_params
    end

    it 'returns body of the soap response' do
      expect(client.call(:api_method, api_method_params)).to eq response.body
    end
  end


  describe '#api_version' do
    let(:client) { AllegroApi::Client.new webapi_key: webapi_key, wsdl: wsdl_url, country_code: country_code }

    before :each do
      stub_wsdl_request_for wsdl_url
    end

    it 'invokes SOAP request' do
      expect(client).to receive(:call).with(:do_query_sys_status,
        sysvar: 3,
        country_id: country_code,
        webapi_key: webapi_key).and_return({do_query_sys_status_response: {info: "1.0.93", ver_key: "1414748778"}})
      client.api_version
    end

    describe 'on succesfull api response' do
      before :each do
        stub_api_response_with 'query_status_success'
      end

      it 'provides current version' do
        expect(client.api_version).to eq '1414748778'
      end
    end

    describe 'on failed api response' do
      before :each do
        stub_api_response_with 'query_status_failed'
      end

      it 'raises api esception' do
        expect { client.api_version }.to raise_error AllegroApi::ApiError
      end
    end
  end

  describe "#sign_in" do
    let(:login) { 'user_login' }
    let(:encrypted_password) { 'encrypted_password' }

    it 'invokes SOAP request' do
      expect(client).to receive(:call).with(:do_login_enc,
        user_login: login,
        user_hash_password: encrypted_password,
        country_code: country_code,
        webapi_key: webapi_key,
        local_version: api_version).and_return({do_login_enc_response: {}})
      client.sign_in login, encrypted_password
    end

    describe 'on success' do
      let(:session) { client.sign_in(login, encrypted_password) }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'login_success'
      end

      it 'returns session object' do
        expect(session).to be_instance_of AllegroApi::Session
      end

      it 'sets id of the session' do
        expect(session.id).to eq 'ce296e49670f156855f1c216288fa3f09fbc21840bcc68bb00_1'
      end

      it 'sets user_id of the session' do
        expect(session.user_id).to eq '39887691'
      end
    end
  end


  describe '#get_fields' do
    it 'invokes SOAP request' do
      expect(client).to receive(:call).with(:do_get_sell_form_fields_ext,
        country_code: country_code, local_version: 0, webapi_key: webapi_key).
        and_return({do_get_sell_form_fields_ext_response: {sell_form_fields: {item: []}}})
        client.get_fields
    end

    describe 'on success' do
      let(:fields) { client.get_fields }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_sell_form_fields_ext_success'
      end

      it 'returns an array of fields' do
        expect(fields).to be_instance_of Array
        expect(fields.size).to eq 5182
        expect(fields).to all(be_instance_of AllegroApi::Field)
      end
    end
  end

  describe '#get_categories' do
    it 'invokes SOAP request' do
      expect(client).to receive(:call).with(:do_get_cats_data,
        country_id: country_code, local_version: 0, webapi_key: webapi_key).
        and_return({do_get_cats_data_response: {cats_list: {item: []}}})
        client.get_categories
    end

    describe 'on success' do
      let(:categories) { client.get_categories }

      before :each do
        stub_wsdl_request_for wsdl_url
        stub_api_response_with 'do_get_cats_data_success'
      end

      it 'returns an array of fields' do
        expect(categories).to be_instance_of Array
        expect(categories.size).to eq 23817
        expect(categories).to all(be_instance_of AllegroApi::Category)
      end
    end
  end
end