module AllegroApi
  module Repository
    class DealEvent < Base
      include StartingPoint

      delegate :to_a, :first, :each, to: :fetch_all_deal_events

      def size
        count_deal_events
      end

      private

      def fetch_all_deal_events
        @enumerator ||= Enumerator.new do |enum|
          events_counter = count_deal_events
          while(events_counter > 0)
            events = get_deal_events
            events.each { |event| enum << event }
            from(events.last.id)
            events_counter -= events.size
          end
        end.memoizing
      end

      def get_deal_events
        params = { session_id: @session.id }
        params[:journal_start] = starting_point if starting_point
        response = @session.client.call(:do_get_site_journal_deals, params)[:do_get_site_journal_deals_response][:site_journal_deals]
        process_items_response(response, AllegroApi::DealEvent)
      end

      def count_deal_events
        params = { session_id: @session.id }
        params[:journal_start] = starting_point if starting_point
        response = @session.client.call(:do_get_site_journal_deals_info, params)[:do_get_site_journal_deals_info_response][:site_journal_deals_info]
        response[:deal_events_count].to_i
      end
    end
  end
end
