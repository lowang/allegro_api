module AllegroApi
  module Repository
    class Base
      include ResponseHelpers

      def initialize(handle)
        @session = handle if handle.is_a? AllegroApi::Session
        @client = handle if handle.is_a? AllegroApi::Client
      end

      def client
        @session && @session.client || @client
      end
    end

    module StartingPoint
      def from(nr)
        @starting_from = nr
        self
      end

      def starting_point
        @starting_from
      end
    end
  end
end
