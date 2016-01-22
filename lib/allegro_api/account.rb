module AllegroApi
  class Account
    include ActiveModel::Model
    attr_accessor :id
    attr_accessor :login
    attr_accessor :rating
    attr_accessor :first_name
    attr_accessor :last_name
    attr_accessor :maiden_name
    attr_accessor :company_name
    attr_accessor :country_id
    attr_accessor :state_id
    attr_accessor :post_code
    attr_accessor :city
    attr_accessor :address
    attr_accessor :email
    attr_accessor :phone
    attr_accessor :phone2
    attr_accessor :is_super_seller
    attr_accessor :is_junior
    attr_accessor :birth_date
    attr_accessor :has_shop
    attr_accessor :is_company
    attr_accessor :is_allegro_standard
    attr_accessor :company
  end
end
