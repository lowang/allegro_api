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
      @savon_adapter = params[:savon_adapter] || :net_http
    end

    def soap_client
      @soap_client ||= Savon.client(wsdl: wsdl, log_level: log_level, log: logger,
        env_namespace: :soapenv, namespace_identifier: :urn, pretty_print_xml: true,
        ssl_verify_mode: :none, adapter: @savon_adapter)
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

    def self.encode_password(password)
      Base64.strict_encode64(Digest::SHA256.new.digest(password))
    end
  end
end
