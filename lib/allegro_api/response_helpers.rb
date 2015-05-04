module AllegroApi
  module ResponseHelpers
    def process_items_response(response, item_klass)
      return [] unless response && response[:item]
      if response[:item].is_a? Array
        response[:item].map do |data|
          item_klass.from_api(data)
        end
      else
        [item_klass.from_api(response[:item])]
      end
    end
  end
end
