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
      Auction.from_api @client.call(:do_get_item_fields, session_id: id, item_id: auction_id)[:do_get_item_fields_response][:item_fields][:item]
    end

    def check_auction(auction)
      @client.call :do_check_new_auction_ext, session_handle: id, fields: {item: auction.to_api}
    end

    def create_auction(auction)
      response = @client.call(:do_new_auction_ext, session_handle: id, fields: {item: auction.to_api})[:do_new_auction_ext_response]
      {id: response[:item_id].to_i, cost: response[:item_info].sub(',', '.').to_f}
    end

    def get_sell_items
      response = @client.call(:do_get_my_sell_items, session_id: id)[:do_get_my_sell_items_response][:sell_items_list]
      process_items_response(response)
    end

    def get_sold_items
      response = @client.call(:do_get_my_sold_items, session_id: id)[:do_get_my_sold_items_response][:sold_items_list]
      process_items_response(response)
    end

    def get_not_sold_items
      response = @client.call(:do_get_my_not_sold_items, session_id: id)[:do_get_my_not_sold_items_response][:not_sold_items_list]
      process_items_response(response)
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