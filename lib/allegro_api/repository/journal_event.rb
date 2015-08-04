module AllegroApi
  module Repository
    class JournalEvent < Base
      include StartingPoint

      delegate :to_a, :first, :each, to: :fetch_all_journal_events

      def size
        count_site_journal_events
      end

      private

      def fetch_all_journal_events
        @enumerator ||= Enumerator.new do |enum|
          events_counter = count_site_journal_events
          while(events_counter > 0)
            events = get_site_journal_events
            events.each { |event| enum << event }
            starting_point = events.last.id
            events_counter -= events.size
          end
        end.memoizing
      end

      def count_site_journal_events
        params = { session_handle: @session.id }
        params[:starting_point] = starting_point if starting_point
        response = @session.client.call(:do_get_site_journal_info, params)
        response = response[:do_get_site_journal_info_response][:site_journal_info]
        response[:items_number].to_i
      end

      def get_site_journal_events
        params = { session_handle: @session.id }
        params[:starting_point] = starting_point if starting_point
        response = @session.client.call(:do_get_site_journal, params)
        # binding.pry
        response = response[:do_get_site_journal_response][:site_journal_array]
        process_items_response(response, AllegroApi::JournalEvent)
      end
    end

  end
end
