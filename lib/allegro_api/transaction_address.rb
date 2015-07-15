module AllegroApi
  class TransactionAddress
    attr_accessor :country
    attr_accessor :street
    attr_accessor :zipcode
    attr_accessor :city
    attr_accessor :full_name
    attr_accessor :company
    attr_accessor :phone
    attr_accessor :nip
    attr_accessor :created_at
    attr_accessor :address_type

    def self.from_api(api_data)
      address = new
      address.country = api_data[:post_buy_form_adr_country].to_i
      address.street = api_data[:post_buy_form_adr_street]
      address.zipcode = api_data[:post_buy_form_adr_postcode]
      address.city = api_data[:post_buy_form_adr_city]
      address.full_name = api_data[:post_buy_form_adr_full_name]
      address.company = api_data[:post_buy_form_adr_company]
      address.phone = api_data[:post_buy_form_adr_phone]
      address.nip = api_data[:post_buy_form_adr_nip]
      address.created_at = api_data[:post_buy_form_created_date]
      address.address_type = api_data[:post_buy_form_adr_type].to_i
      address
    end
  end
end
