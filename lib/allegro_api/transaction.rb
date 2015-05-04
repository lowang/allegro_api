module AllegroApi
  class Transaction
    attr_accessor :id
    attr_accessor :items
    attr_accessor :buyer_id
    attr_accessor :total_amount
    attr_accessor :shipment_amount
    attr_accessor :invoice_required
    attr_accessor :message
    attr_accessor :invoice_data
    attr_accessor :shipment_address
    attr_accessor :payment_type
    attr_accessor :payment_id
    attr_accessor :payment_status
    attr_accessor :payment_initiated_at
    attr_accessor :payment_received_at
    attr_accessor :payment_canceled_at
    attr_accessor :shipment_method_id
    attr_accessor :invoice_address
    attr_accessor :shipment_address
    attr_accessor :delivery_point_address

    extend ResponseHelpers

    def initialize
      @items = []
    end

    def self.from_api(api_data)
      transaction = new
      transaction.id = api_data[:post_buy_form_id].to_i
      transaction.items = process_items_response(api_data[:post_buy_form_items], TransactionItem)
      transaction.message = api_data[:post_buy_form_msg_to_seller]
      transaction.total_amount = api_data[:post_buy_form_amount].to_f
      transaction.shipment_amount = api_data[:post_buy_form_postage_amount].to_f
      transaction.invoice_required = (api_data[:post_buy_form_invoice_option] == '1')
      transaction.payment_type = api_data[:post_buy_form_pay_type]
      transaction.payment_id = api_data[:post_buy_form_pay_id].to_i
      transaction.payment_status = api_data[:post_buy_form_pay_status]
      transaction.payment_initiated_at = api_data[:post_buy_form_date_init]
      transaction.payment_received_at = api_data[:post_buy_form_date_recv]
      transaction.payment_canceled_at = api_data[:post_buy_form_date_cancel]
      transaction.shipment_method_id = api_data[:post_buy_form_shipment_id].to_i
      transaction.invoice_address = TransactionAddress.from_api(api_data[:post_buy_form_invoice_data])
      transaction.shipment_address = TransactionAddress.from_api(api_data[:post_buy_form_shipment_address])
      transaction.delivery_point_address = TransactionAddress.from_api(api_data[:post_buy_form_gd_address])
      transaction
    end
  end
end
