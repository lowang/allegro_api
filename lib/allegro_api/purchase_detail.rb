module AllegroApi
  class PurchaseDetail

    class User
      attr_accessor :id, :login, :first_name, :last_name, :company
      attr_accessor :country_id, :state_id, :post_code, :city, :address
      attr_accessor :email, :phone

      def self.from_api(data)
        user = new
        user.id = data[:user_id]
        user.login = data[:user_login]
        user.first_name = data[:user_first_name]
        user.last_name = data[:user_last_name]
        user.company = data[:user_company]
        user.country_id = data[:user_country_id]
        user.state_id = data[:user_state_id]
        user.post_code = data[:user_postcode]
        user.city = data[:user_city]
        user.address = data[:user_address]
        user.email = data[:user_email]
        user.phone = data[:user_phone]
        user
      end
    end

    class ShipmentAddress
      attr_accessor :id, :first_name, :last_name, :company
      attr_accessor :country_id, :post_code, :city, :address

      def self.from_api(data)
        address = new
        address.id = data[:user_id]
        address.first_name = data[:user_first_name]
        address.last_name = data[:user_last_name]
        address.company = data[:user_company]
        address.country_id = data[:user_country_id]
        address.post_code = data[:user_postcode]
        address.city = data[:user_city]
        address.address = data[:user_address]
        address
      end
    end

    attr_accessor :item_id
    attr_accessor :user
    attr_accessor :shipment_address

    def self.from_api(data)
      Array.wrap(data[:users_post_buy_data][:item]).collect do |user_data|
        event = new
        event.item_id = data[:item_id].to_i
        user_data = {user_data: user_data.last } if user_data.is_a?(Array)
        event.user = User.from_api(user_data[:user_data])
        event.shipment_address = ShipmentAddress.from_api(user_data[:user_sent_to_data]) if user_data[:user_sent_to_data]
        event
      end
    end
  end
end
