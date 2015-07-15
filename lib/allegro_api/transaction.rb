require 'ostruct'

module AllegroApi
  class Transaction
    attr_accessor :id, 
    attr_accessor :message
    attr_accessor :total_amount
    attr_accessor :shipment_amount
    attr_accessor :shipment_method_id
    attr_accessor :invoice_required
    attr_accessor :items, :buyer, :invoice_address, :shipment_address, :delivery_point_address, :payment
    
    extend ResponseHelpers

    def self.from_api(data)
      transaction = Transaction.new
      transaction.id = data[:post_buy_form_id].to_i
      transaction.message = api_data[:post_buy_form_msg_to_seller]
      transaction.total_amount = api_data[:post_buy_form_amount].to_f
      transaction.shipment_amount = api_data[:post_buy_form_postage_amount].to_f
      transaction.shipment_method_id = data[:post_buy_form_shipment_id].to_i
      transaction.invoice_required = (api_data[:post_buy_form_invoice_option] == '1')

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

      transaction.invoice_address = TransactionAddress.from_api(data[:post_buy_form_invoice_data])
      transaction.shipment_address = TransactionAddress.from_api(data[:post_buy_form_shipment_address])
      transaction.delivery_point_address = TransactionAddress.from_api(data[:post_buy_form_gd_address])
      
      transaction.payment = OpenStruct.new
      transaction.payment.type = data[:post_buy_form_pay_type]
      transaction.payment.id = data[:post_buy_form_pay_id].to_i
      transaction.payment.status = data[:post_buy_form_pay_status]
      transaction.payment.initiated_at = data[:post_buy_form_date_init]
      transaction.payment.received_at = data[:post_buy_form_date_recv]
      transaction.payment.canceled_at = data[:post_buy_form_date_cancel]
      
      transaction
    end
  end
end
