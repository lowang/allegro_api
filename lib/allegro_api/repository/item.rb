module AllegroApi
  module Repository
    class Item < Base
      # number of items per page in get_*_items requests
      GET_ITEMS_PAGE_SIZE = 100

      delegate :to_a, :first, :each, to: :fetch_all_items

      def sell # zakładka "Sprzedaję"
        @scope = :sell_items
        self
      end

      def sold # zakładka "Sprzedane"
        @scope = :sold_items
        self
      end

      def not_sold # zakładka "Niesprzedane"
        @scope = :not_sold_items
        self
      end

      def find(item_ids)
        items = []
        item_ids.each_slice(GET_ITEMS_PAGE_SIZE) do |batch_ids|
          _, fetched_items = where(item_ids: {item: batch_ids}).get_items
          items.concat fetched_items
        end
        items
      end

      def size
        counter, items = page(0).get_items
        counter
      end

      def search(phrase)
        @search_phrase = phrase
        self
      end

      def page(page)
        @page = page
        self
      end

      # expose it as public so chaining works
      def get_items
        response = @session.client.call("do_get_my_#{scope}".to_sym, build_params)
        response_name = "do_get_my_#{scope}_response".to_sym
        all_items_count = response[response_name]["#{scope}_counter".to_sym].to_i
        items = process_items_response(response[response_name]["#{scope}_list".to_sym], AllegroApi::Item)
        [all_items_count, items]
      end

      private

      def where(conditions={})
        if conditions[:item_ids]
          @item_ids = conditions[:item_ids]
        else
          raise("where conditions only supports `item_ids`")
        end
        self
      end

      def scope
        @scope || raise("scope not supplied")
      end

      def fetch_all_items
        @enumerator ||= Enumerator.new do |enum|
          items_counter = nil
          current_page = 0
          while(!items_counter || items_counter > 0)
            counter, items = page(current_page).get_items
            items_counter = counter unless items_counter
            items.each { |item| enum << item }
            items_counter -= items.size
            current_page += 1
          end
        end.memoizing
      end

      # it must be ordered hash, otherwise allegro wsdl will raise exception
      def build_params #(params={})
        params = { session_id: @session.id }
        params[:search_value] = @search_phrase if @search_phrase
        params[:item_ids] = @item_ids if @item_ids
        params.merge!({ page_size: GET_ITEMS_PAGE_SIZE, page_number: @page.to_i }) unless @item_ids
        params
      end
    end
  end
end
