module AllegroApi
  class Session
    attr_reader :login
    attr_reader :user_id
    attr_reader :id

    # number of items per page in get_*_items requests
    GET_ITEMS_PAGE_SIZE = 100


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
      response = @client.call(:do_check_new_auction_ext, session_handle: id, fields: {item: auction.to_api})[:do_check_new_auction_ext_response]
       {cost: response[:item_price].sub(',', '.').to_f, description: response[:item_price_desc]}
    end

    def create_auction(auction)
      response = @client.call(:do_new_auction_ext, session_handle: id, fields: {item: auction.to_api})[:do_new_auction_ext_response]
      {id: response[:item_id].to_i, cost: response[:item_info].sub(',', '.').to_f}
    end

    def get_items(item_type, *items_ids)
      if items_ids.empty?
        get_items_in_pages(item_type)
      else
        get_items_by_id(item_type, items_ids)
      end
    end

    def get_sell_items(*items_ids)
      get_items(:sell_items, *items_ids)
    end

    def get_sold_items(*items_ids)
      get_items(:sold_items, *items_ids)
    end

    def get_not_sold_items(*items_ids)
      get_items(:not_sold_items, *items_ids)
    end

    def auctions
      Enumerator.new do |collection|
        get_sell_items.each do |item|
          collection << find_auction(item.id)
        end
      end
    end

    def get_site_journal_events(starting_point = nil)
      params = { session_handle: id }
      params[:starting_point] = starting_point if starting_point
      response = @client.call(:do_get_site_journal, params)[:do_get_site_journal_response][:site_journal_array]
      if response && response[:item]
        response[:item].map {|api_data| JournalEvent.from_api(api_data)}
      else
        []
      end
    end

    def count_site_journal_events(starting_point = nil)
      params = { session_handle: id }
      params[:starting_point] = starting_point if starting_point
      response = @client.call(:do_get_site_journal_info, params)[:do_get_site_journal_info_response][:site_journal_info]
      response[:items_number].to_i
    end

    def for_each_site_journal_events_page(starting_point = nil, &block)
      events_counter = count_site_journal_events(starting_point)
      while(events_counter > 0)
        events = get_site_journal_events(starting_point)
        block.call(events)
        starting_point = events.last.id
        events_counter -= events.size
      end
    end

    def get_deal_events(starting_point = nil)
      params = { session_id: id }
      params[:journal_start] = starting_point if starting_point
      response = @client.call(:do_get_site_journal_deals, params)[:do_get_site_journal_deals_response][:site_journal_deals]
      if response && response[:item]
        response[:item].map {|api_data| DealEvent.from_api(api_data)}
      else
        []
      end
    end

    def count_deal_events(starting_point = nil)
      params = { session_id: id }
      params[:journal_start] = starting_point if starting_point
      response = @client.call(:do_get_site_journal_deals_info, params)[:do_get_site_journal_deals_info_response][:site_journal_deals_info]
      response[:deal_events_count].to_i
    end

    def for_each_deal_events_page(starting_point = nil, &block)
      events_counter = count_deal_events(starting_point)
      while(events_counter > 0)
        events = get_deal_events(starting_point)
        block.call(events)
        starting_point = events.last.id
        events_counter -= events.size
      end
    end

    private

    def get_items_by_id(item_type, items_ids)
      items = []
      request_name = "do_get_my_#{item_type}".to_sym
      response_name = "do_get_my_#{item_type}_response".to_sym
      items_list_name = "#{item_type}_list".to_sym
      items_ids.each_slice(GET_ITEMS_PAGE_SIZE) do |batch_ids|
        response = @client.call(request_name, session_id: id,
          item_ids: {item: batch_ids})
        items += process_items_response(response[response_name][items_list_name])
      end
      items
    end

    def get_items_in_pages(item_type)
      counter, items = get_items_page(0, item_type)
      if counter > GET_ITEMS_PAGE_SIZE
        items = (1...(counter / GET_ITEMS_PAGE_SIZE + 1)).inject(items) do |memo, page|
          _, page_items = get_items_page(page, item_type)
          memo + page_items
        end
      end
      items
    end

    def get_items_page(page, item_type)
      response = @client.call("do_get_my_#{item_type}".to_sym, session_id: id,
        page_size: GET_ITEMS_PAGE_SIZE, page_number: page)
      response_name = "do_get_my_#{item_type}_response".to_sym
      all_items_count = response[response_name]["#{item_type}_counter".to_sym].to_i
      items = process_items_response(response[response_name]["#{item_type}_list".to_sym])
      return [all_items_count, items]
    end

    def build_get_items_params(items_ids, page = 0)
      params = {session_id: id}
      params[:page_size] = GET_ITEMS_PAGE_SIZE
      params[:page_number] = page
      params[:item_ids] = {item: items_ids} unless items_ids.empty?
      params
    end

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
