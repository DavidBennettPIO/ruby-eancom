require 'ruby_eancom/purchase_order_line'

class EANCOM::PurchaseOrder

  attr_accessor :order_number,
                :order_date,
                :requested_delivery_date,
                :supplier_code,
                :ship_store_code,
                :invoice_store_code,
                :line_items

  def from_eancom hash
    self.order_number             = hash[:order_number]             unless hash[:order_number].nil?
    self.order_date               = hash[:order_date]               unless hash[:order_date].nil?
    self.requested_delivery_date  = hash[:requested_delivery_date]  unless hash[:requested_delivery_date].nil?
    self.supplier_code            = hash[:supplier_code]            unless hash[:supplier_code].nil?
    self.ship_store_code          = hash[:ship_store_code]          unless hash[:ship_store_code].nil?
    self.invoice_store_code       = hash[:invoice_store_code]       unless hash[:invoice_store_code].nil?
    self.line_items ||= []
    unless hash[:line_items].nil?
      hash[:line_items].each do |line_item|
        pol = EANCOM::PurchaseOrderLine.new
        pol.from_eancom(line_item)
        self.line_items << pol
      end
    end

  end

  def to_eancom
    {
        order_number: self.order_number,
        order_date: self.order_date,
        requested_delivery_date: self.requested_delivery_date,
        supplier_code: self.supplier_code,
        ship_store_code: self.ship_store_code,
        invoice_store_code: self.invoice_store_code,
        line_items: self.line_items.map(&:to_eancom)
    }
  end

end