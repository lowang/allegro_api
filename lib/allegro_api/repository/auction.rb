module AllegroApi
  module Repository
    class Auction < Base
      delegate :to_a, :first, :each, to: :fetch_auctions_from_items

      %i( sell sold not_sold ).each do |scope|
        define_method scope do
          @scope = scope
          self
        end
      end

      # metoda pobiera wszystkie pola formularza do wystawiania aukcji
      # @return [Array]
      def fields
        response = @session.client.call(:do_get_sell_form_fields_ext,
          country_code: @session.client.country_code,
          local_version: 0,
          webapi_key: @session.client.webapi_key)[:do_get_sell_form_fields_ext_response][:sell_form_fields][:item]
        if response.is_a? Array
          response.map {|data| AllegroApi::Field.from_api(data) }
        else
          AllegroApi::Field.from_api(response)
        end
      end

      def find(auction_id)
        response = @session.client.call(:do_get_item_fields, session_id: @session.id, item_id: auction_id)[:do_get_item_fields_response][:item_fields][:item]
        auction = AllegroApi::Auction.from_api(response)
        auction.id = auction_id
        auction
      end

      def check(auction)
        response = @session.client.call(:do_check_new_auction_ext, session_handle: @session.id, fields: {item: auction.to_api})[:do_check_new_auction_ext_response]
         {cost: response[:item_price].sub(',', '.').to_f, description: response[:item_price_desc]}
      end

      def create(auction)
        response = @session.client.call(:do_new_auction_ext, session_handle: @session.id, fields: {item: auction.to_api})[:do_new_auction_ext_response]
        {id: response[:item_id].to_i, cost: response[:item_info].sub(',', '.').to_f}
      end

      private

      def scope
        @scope || raise("scope not supplied")
      end

      def fetch_auctions_from_items
        @enumerator ||= Enumerator.new do |collection|
          @session.items.send(scope).each do |item|
            collection << find(item.id)
          end
        end.memoizing
      end

    end
  end
end
