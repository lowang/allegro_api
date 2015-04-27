module AllegroApi
  class DealEvent
    attr_accessor :id
    attr_accessor :event_type
    attr_accessor :created_at
    attr_accessor :deal_id
    attr_accessor :transaction_id
    attr_accessor :seller_id
    attr_accessor :item_id
    attr_accessor :buyer_id
    attr_accessor :quantity

    def self.from_api(data)
      event = new
      event.id = data[:deal_event_id].to_i
      event.event_type = data[:deal_event_type].to_i
      event.created_at = Time.at data[:deal_event_time].to_i
      event.transaction_id = data[:deal_transaction_id].to_i
      event.seller_id = data[:deal_seller_id].to_i
      event.item_id = data[:deal_item_id].to_i
      event.buyer_id = data[:deal_buyer_id].to_i
      event.quantity = data[:deal_quantity].to_i
      event
    end
  end
end
