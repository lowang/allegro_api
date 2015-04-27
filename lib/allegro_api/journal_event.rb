module AllegroApi
  class JournalEvent
    attr_accessor :id
    attr_accessor :item_id
    attr_accessor :change_type
    attr_accessor :changed_at
    attr_accessor :current_price
    attr_accessor :seller_id

    def self.from_api(data)
      event = new
      event.id = data[:row_id].to_i
      event.item_id = data[:item_id].to_i
      event.change_type = data[:change_type]
      event.changed_at = Time.at data[:change_date].to_i
      event.current_price = data[:current_price].to_i
      event.seller_id = data[:item_seller_id].to_i
      event
    end

    def buy_now?
      change_type == 'now'
    end

    def auction_ended?
      change_type == 'end'
    end
  end
end
