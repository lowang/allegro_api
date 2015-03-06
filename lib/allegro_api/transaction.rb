require 'ostruct'

module AllegroApi
  class Transaction
    attr_accessor :id, :items, :buyer, :shipment_address

    def self.from_api(data)
      transaction = Transaction.new
      transaction.id = data[:post_buy_form_id].to_i

      transaction.items = []
      data[:post_buy_form_items].each do |key,dataitem|
        item = AllegroApi::Item.new
        item.id = dataitem[:post_buy_form_it_id].to_i
        item.title = dataitem[:post_buy_form_it_title]
        item.amount = BigDecimal.new dataitem[:post_buy_form_it_amount]
        item.deals = []
        dataitem[:post_buy_form_it_deals].each do |key, dealitem|
          deal = OpenStruct.new
          deal.quantity = dealitem[:deal_quantity].to_i
          deal.datetime = dealitem[:deal_date]
          item.deals << deal
        end
        transaction.items << item
      end

      transaction.buyer = OpenStruct.new
      transaction.buyer.id = data[:post_buy_form_buyer_id].to_i
      transaction.buyer.email = data[:post_buy_form_buyer_email]
      transaction.buyer.login = data[:post_buy_form_buyer_login]

      transaction.shipment_address = OpenStruct.new
      transaction.shipment_address.full_name = data[:post_buy_form_shipment_address][:post_buy_form_adr_full_name]
      transaction.shipment_address.company = data[:post_buy_form_shipment_address][:post_buy_form_adr_company]
      transaction.shipment_address.country_id = data[:post_buy_form_shipment_address][:post_buy_form_adr_country].to_i
      transaction.shipment_address.post_code = data[:post_buy_form_shipment_address][:post_buy_form_adr_postcode]
      transaction.shipment_address.city = data[:post_buy_form_shipment_address][:post_buy_form_adr_city]
      transaction.shipment_address.address = data[:post_buy_form_shipment_address][:post_buy_form_adr_street]
      transaction.shipment_address.phone = data[:post_buy_form_shipment_address][:post_buy_form_adr_phone]
      transaction
    end
  end
end
