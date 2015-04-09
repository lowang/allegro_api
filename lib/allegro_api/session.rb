module AllegroApi
  class Session
    attr_reader :login
    attr_reader :user_id
    attr_reader :id

    def initialize(client, id, user_id)
      @client = client
      @id = id
      @user_id = user_id
    end

    def find_auction(auction_id)
      auction = Auction.from_api @client.call(:do_get_item_fields, session_id: id, item_id: auction_id)[:do_get_item_fields_response][:item_fields][:item]
      auction.id = auction_id
      auction
    end

    def check_auction(auction)
      @client.call :do_check_new_auction_ext, session_handle: id, fields: {item: auction.to_api}
    end

    def create_auction(auction)
      response = @client.call(:do_new_auction_ext, session_handle: id, fields: {item: auction.to_api})[:do_new_auction_ext_response]
      {id: response[:item_id].to_i, cost: response[:item_info].sub(',', '.').to_f}
    end

    # type: sell|sold|not_sold|won
    def get_items(type)
      response = @client.call(:"do_get_my_#{type}_items", session_id: id)[:"do_get_my_#{type}_items_response"][:"#{type}_items_list"]
      process_items_response(response)
    end

    def get_counterparty_data(items_ids)
      items_ids = Array.wrap(items_ids)
      response = @client.call(:do_get_post_buy_data, session_handle: id, items_array: {item: items_ids})[:do_get_post_buy_data_response][:items_post_buy_data]
      Hash[*response[:item].map do |item|
        [item[:item_id], item[:users_post_buy_data][:item]]
      end.flatten]
    end

    # type: seller|buyer
    def get_transaction_details(transactions_ids, type='seller')
      transactions_ids = Array.wrap(transactions_ids)
      response = @client.call(:"do_get_post_buy_forms_data_for_#{type}s", session_id: id, transactionsIdsArray: {item: transactions_ids})
      data = response[:"do_get_post_buy_forms_data_for_#{type}s_response"][:"post_buy_form_data"][:item]
      AllegroApi::Transaction.from_api(data)
    end

    # type: seller|buyer
    def get_transactions(items_ids, type='seller')
      items_ids = Array.wrap(items_ids)
      response = @client.call(:do_get_transactions_i_ds, session_handle: id, items_id_array: {item: items_ids}, user_role: type)
      Array.wrap(response[:do_get_transactions_i_ds_response][:transactions_ids_array].try(:[],:item))
    end

    def auctions
      Enumerator.new do |collection|
        get_items('sell').each do |item|
          collection << find_auction(item.id)
        end
      end
    end

    def get_user_items
      client.get_user_items(user_id)
    end

    private

    def process_items_response(response)
      return [] unless response && response[:item]
      if response[:item].is_a? Array
        response[:item].map do |data|
          Item.from_api(data)
        end
      else
        [Item.from_api(response[:item])]
      end
    end
  end
end
