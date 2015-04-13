module AllegroApi
  class Client
    attr_accessor :wsdl
    attr_accessor :webapi_key
    attr_accessor :country_code
    attr_accessor :logger
    attr_accessor :log_level

    def initialize(params = {})
      @wsdl = params[:wsdl] || AllegroApi.wsdl
      @webapi_key = params[:webapi_key] || AllegroApi.webapi_key
      @country_code = params[:country_code] || 1
      @api_version = params[:api_version]
      @logger = params[:logger]
      @log_level = params[:log_level] || :info
    end


    def soap_client
      @soap_client ||= Savon.client(wsdl: wsdl, log_level: log_level, log: logger,
        env_namespace: :soapenv, namespace_identifier: :urn, pretty_print_xml: true,
        ssl_verify_mode: :none)
    end


    def call(method_name, params = {})
      soap_client.call(method_name, message: params).body
    rescue Savon::SOAPFault => error
      raise ApiError.new(error.message)
    end


    # metoda zwraca aktualną (lub ustawioną w konstruktorze) wersję api
    # @return [String] wersja api
    def api_version
      @api_version ||= call(:do_query_sys_status,
        sysvar: 3,
        country_id: country_code,
        webapi_key: webapi_key)[:do_query_sys_status_response][:ver_key]
    end

    # metoda do autentykacji użytkownika
    # @param login [String] login użytkownika
    # @param encrypted_password [String] zakodowane hasło użytkownika (Base64.strict_encode64(Digest::SHA256.new.digest(password)))
    # @return [Session]
    def sign_in(login, encrypted_password)
      response = call(:do_login_enc,
        user_login: login,
        user_hash_password: encrypted_password,
        country_code: country_code,
        webapi_key: webapi_key,
        local_version: api_version)[:do_login_enc_response]
      Session.new(self, response[:session_handle_part], response[:user_id])
    end


    # metoda pobiera wszystkie pola formularza do wystawiania aukcji
    # @return [Array]
    def get_fields
      response = call(:do_get_sell_form_fields_ext,
        country_code: country_code,
        local_version: 0,
        webapi_key: webapi_key)[:do_get_sell_form_fields_ext_response][:sell_form_fields][:item]
        if response.is_a? Array
          response.map {|data| Field.from_api(data) }
        else
          Field.from_api(response)
        end
    end


    # metoda pobiera listę kategorii z allegro
    def get_categories
      response = call(:do_get_cats_data,
        country_id: country_code,
        local_version: 0,
        webapi_key: webapi_key)[:do_get_cats_data_response][:cats_list][:item]
      if response.is_a? Array
        response.map {|data| Category.from_api(data) }
      else
        Category.from_api(response)
      end
    end

    def get_user_id(login)
      response = call(:"do_get_user_id", countryId: country_code, userLogin: login, webapiKey: webapi_key)
      response[:do_get_user_id_response][:user_id]
    end

    def get_user_items(user_id)
      response = call(:"do_get_items_list", webapi_key: webapi_key, countryId: country_code,
        filterOptions:[{item: {filterId:"userId", filterValueId:[{item: user_id}]}}],
        resultSize: 100)
      Array.wrap(response[:do_get_items_list_response][:items_list].try(:[],:item))
    end

    def self.encode_password(password)
      Base64.strict_encode64(Digest::SHA256.new.digest(password))
    end
  end
end
