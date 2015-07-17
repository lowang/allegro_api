require 'ostruct'

module AllegroApi
  class Transaction
    attr_accessor :id
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
      transaction.message = data[:post_buy_form_msg_to_seller]
      transaction.total_amount = data[:post_buy_form_amount].to_f
      transaction.shipment_amount = data[:post_buy_form_postage_amount].to_f
      transaction.shipment_method_id = data[:post_buy_form_shipment_id].to_i
      transaction.invoice_required = (data[:post_buy_form_invoice_option] == '1')

      transaction.items = process_items_response(data[:post_buy_form_items], TransactionItem)

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
