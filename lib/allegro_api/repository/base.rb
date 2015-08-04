module AllegroApi
  module Repository
    class Base
      include ResponseHelpers

      def initialize(session)
        @session = session
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
