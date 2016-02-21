module AllegroApi
  module Repository
    class PurchaseDetail < Base

      GET_POST_BUY_DATA_PAGE_SIZE = 25

      def find(item_ids)
        items = []
        Array.wrap(item_ids).each_slice(GET_POST_BUY_DATA_PAGE_SIZE) do |batch_ids|
          fetched_items = get_post_buy_data(batch_ids)
          items.concat fetched_items
        end
        items
      end

      private

      def get_post_buy_data(item_ids)
        params = { session_handle: @session.id, items_array: { item: item_ids } }
        response = @session.client.call(:do_get_post_buy_data, params)[:do_get_post_buy_data_response][:items_post_buy_data]
        process_items_response(response, AllegroApi::PurchaseDetail).flatten
      end

    end
  end
end
