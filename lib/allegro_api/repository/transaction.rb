module AllegroApi
  module Repository
    class Transaction < Base
      GET_POST_BUY_PAGE_SIZE = 25

      %i( seller buyer ).each do |scope|
        define_method scope do
          @scope = scope
          self
        end
      end

      def find(transaction_ids)
        get_transactions(Array.wrap(transaction_ids))
      end

      private

      def scope
        @scope || raise("scope not supplied")
      end

      def get_transactions(transaction_ids)
        transactions = []
        transaction_ids.each_slice(GET_POST_BUY_PAGE_SIZE) do |slice_ids|
          params = { session_id: @session.id, transactions_ids_array: { item: slice_ids }}
          response = @session.client.call(:"do_get_post_buy_forms_data_for_#{scope}s", params)
          response = response[:"do_get_post_buy_forms_data_for_#{scope}s_response"][:"post_buy_form_data"]
          transactions.concat process_items_response(response, AllegroApi::Transaction)
        end
        transactions
      end

    end
  end
end
