module AllegroApi
  module Repository
    class Field < Base
      delegate :to_a, :first, :each, to: :fetch_fields

      private

      # metoda pobiera wszystkie pola formularza do wystawiania aukcji
      # @return [Array]
      def fetch_fields
        @enumerator ||= Enumerator.new do |collection|
          response = client.call(:do_get_sell_form_fields_ext,
            country_code: client.country_code,
            local_version: 0,
            webapi_key: client.webapi_key)[:do_get_sell_form_fields_ext_response][:sell_form_fields][:item]
          if response.is_a? Array
            response.each {|data| collection << AllegroApi::Field.from_api(data) }
          else
            collection << AllegroApi::Field.from_api(response)
          end
        end.memoizing
      end

    end
  end
end
