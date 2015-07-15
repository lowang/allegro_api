module AllegroApi
  class TransactionItem
    attr_accessor :id
    attr_accessor :quantity
    attr_accessor :amount
    attr_accessor :title
    attr_accessor :country
    attr_accessor :price
    attr_accessor :deals

    extend ResponseHelpers

    def self.from_api(api_data)
      item = new
      item.id = api_data[:post_buy_form_it_id].to_i
      item.quantity = api_data[:post_buy_form_it_quantity].to_i
      item.amount = api_data[:post_buy_form_it_amount].sub(',', '.').to_f
      item.title = api_data[:post_buy_form_it_title]
      item.country = api_data[:post_buy_form_it_country].to_i
      item.price = api_data[:post_buy_form_it_price].sub(',', '.').to_f
      item.deals = process_items_response(api_data[:post_buy_form_it_deals], TransactionItemDeal)
      item
    end
  end
end
