module AllegroApi
  module Repository
    class Category < Base
      delegate :to_a, :first, :each, to: :get_categories

      private

      # metoda pobiera listę kategorii z allegro
      def get_categories
        response = client.call(:do_get_cats_data,
          country_id: client.country_code,
          local_version: 0,
          webapi_key: client.webapi_key)[:do_get_cats_data_response][:cats_list][:item]
        if response.is_a? Array
          response.map {|data| AllegroApi::Category.from_api(data) }
        else
          AllegroApi::Category.from_api(response)
        end
      end
    end
  end
end
