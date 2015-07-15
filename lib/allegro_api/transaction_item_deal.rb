class AllegroApi::TransactionItemDeal
  attr_accessor :id
  attr_accessor :price
  attr_accessor :quantity
  attr_accessor :created_at
  attr_accessor :discounted

  alias :discounted? :discounted

  def self.from_api(api_data)
    deal = new
    deal.id = api_data[:deal_id].to_i
    deal.price = api_data[:deal_final_price].to_f
    deal.created_at = api_data[:deal_date]
    deal.discounted = api_data[:deal_was_discounted]
    deal
  end
end
