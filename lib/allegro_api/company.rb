module AllegroApi
  class Company
    include ActiveModel::Model
    attr_accessor :name
    attr_accessor :type
    attr_accessor :nip
    attr_accessor :regon
    attr_accessor :krs
    attr_accessor :activity_sort
    attr_accessor :worker_first_name
    attr_accessor :worker_last_name
    attr_accessor :address
    attr_accessor :post_code
    attr_accessor :city
    attr_accessor :country_id
    attr_accessor :state_id
  end
end
