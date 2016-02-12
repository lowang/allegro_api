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

      def update(auction)
        response = @session.client.call(:do_change_item_fields, session_id: @session.id, item_id: auction.id, fields_to_modify: {item: auction.to_api})[:do_change_item_fields_response]
        {id: response[:changed_item][:item_id].to_i}
      end

      def destroy(auction)
        @session.client.call(:do_finish_item, session_handle: @session.id, finish_item_id: auction.id)[:do_finish_item_response]
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
