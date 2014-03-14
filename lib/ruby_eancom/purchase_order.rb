require 'ruby_eancom/line_item'

class EANCOM::PurchaseOrder

  attr_accessor :document_name,
                :order_number,
                :order_date,
                :message_date,
                :requested_delivery_date,
                :supplier_code,
                :ship_to_store_code,
                :invoice_to_store_code,
                :line_items

  def from_eancom hash
    @document_name                  = hash[:document_name]              unless hash[:document_name].nil?
    @order_number                   = hash[:order_number]               unless hash[:order_number].nil?
    @order_date                     = hash[:order_date]                 unless hash[:order_date].nil?
    @message_date                   = hash[:message_date]               unless hash[:message_date].nil?
    @requested_delivery_date        = hash[:requested_delivery_date]    unless hash[:requested_delivery_date].nil?
    @supplier_code                  = hash[:supplier_code]              unless hash[:supplier_code].nil?
    @ship_to_store_code             = hash[:ship_to_store_code]         unless hash[:ship_to_store_code].nil?
    @invoice_to_store_code          = hash[:invoice_to_store_code]      unless hash[:invoice_to_store_code].nil?
    @line_items ||= []
    unless hash[:line_items].nil?
      hash[:line_items].each do |line_item|
        li = EANCOM::LineItem.new
        li.from_eancom(line_item)
        @line_items << li
      end
    end

  end

  def to_eancom
    hash = {}
    hash[:document_name]            = @document_name                    unless @document_name.nil?
    hash[:order_number]             = @order_number                     unless @order_number.nil?
    hash[:order_date]               = @order_date                       unless @order_date.nil?
    hash[:message_date]             = @message_date                     unless @message_date.nil?
    hash[:requested_delivery_date]  = @requested_delivery_date          unless @requested_delivery_date.nil?
    hash[:supplier_code]            = @supplier_code                    unless @supplier_code.nil?
    hash[:ship_to_store_code]       = @ship_to_store_code               unless @ship_to_store_code.nil?
    hash[:invoice_to_store_code]    = @invoice_to_store_code            unless @invoice_to_store_code.nil?
    hash[:line_items]               = @line_items.map(&:to_eancom)      unless @line_items.nil? || @line_items.size < 1
    hash
  end

end