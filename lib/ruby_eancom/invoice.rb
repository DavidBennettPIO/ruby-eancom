require 'ruby_eancom/line_item'

class EANCOM::Invoice

  attr_accessor :document_name,
                :invoice_number,
                :invoice_date,
                :message_date,
                :terms_due_date,
                :buyer_order_number,
                :supplier_order_number,
                :supplier_code,
                :ship_to_store_code,
                :invoice_to_store_code,
                :line_items,
                :tax_code,
                :charge_amount,
                :total_invoice_amount,
                :total_line_items_amount,
                :invoice_amount,
                :total_message_amount,
                :tax_amount,
                :taxable_amount,
                :total_amount,
                :total_discountable_amount,
                :total_charges_amount,
                :total_discount_amount,
                :total_tax_amount,
                :line_item_amount

  def from_eancom hash
    @document_name                      = hash[:document_name]              unless hash[:document_name].nil?
    @invoice_number                     = hash[:invoice_number]             unless hash[:invoice_number].nil?
    @invoice_date                       = hash[:invoice_date]               unless hash[:invoice_date].nil?
    @message_date                       = hash[:message_date]               unless hash[:message_date].nil?
    @terms_due_date                     = hash[:terms_due_date]             unless hash[:terms_due_date].nil?
    @buyer_order_number                 = hash[:buyer_order_number]         unless hash[:buyer_order_number].nil?
    @supplier_order_number              = hash[:supplier_order_number]      unless hash[:supplier_order_number].nil?
    @supplier_code                      = hash[:supplier_code]              unless hash[:supplier_code].nil?
    @ship_to_store_code                 = hash[:ship_to_store_code]         unless hash[:ship_to_store_code].nil?
    @invoice_to_store_code              = hash[:invoice_to_store_code]      unless hash[:invoice_to_store_code].nil?
    @line_items ||= []
    unless hash[:line_items].nil?
      hash[:line_items].each do |line_item|
        li = EANCOM::LineItem.new
        li.from_eancom(line_item)
        @line_items << li
      end
    end
    @charge_amount                      = hash[:charge_amount]              unless hash[:charge_amount].nil?
    @total_invoice_amount               = hash[:total_invoice_amount]       unless hash[:total_invoice_amount].nil?
    @total_line_items_amount            = hash[:total_line_items_amount]    unless hash[:total_line_items_amount].nil?
    @invoice_amount                     = hash[:invoice_amount]             unless hash[:invoice_amount].nil?
    @total_message_amount               = hash[:total_message_amount]       unless hash[:total_message_amount].nil?
    @tax_amount                         = hash[:tax_amount]                 unless hash[:tax_amount].nil?
    @taxable_amount                     = hash[:taxable_amount]             unless hash[:taxable_amount].nil?
    @total_amount                       = hash[:total_amount]               unless hash[:total_amount].nil?
    @total_discountable_amount          = hash[:total_discountable_amount]  unless hash[:total_discountable_amount].nil?
    @total_charges_amount               = hash[:total_charges_amount]       unless hash[:total_charges_amount].nil?
    @total_discount_amount              = hash[:total_discount_amount]      unless hash[:total_discount_amount].nil?
    @total_tax_amount                   = hash[:total_tax_amount]           unless hash[:total_tax_amount].nil?
    @line_item_amount                   = hash[:line_item_amount]           unless hash[:line_item_amount].nil?
  end

  def to_eancom
    hash = {}
    hash[:document_name]                = @document_name                    unless @document_name.nil?
    hash[:invoice_number]               = @invoice_number                   unless @invoice_number.nil?
    hash[:invoice_date]                 = @invoice_date                     unless @invoice_date.nil?
    hash[:message_date]                 = @message_date                     unless @message_date.nil?
    hash[:terms_due_date]               = @terms_due_date                   unless @terms_due_date.nil?
    hash[:buyer_order_number]           = @buyer_order_number               unless @buyer_order_number.nil?
    hash[:supplier_order_number]        = @supplier_order_number            unless @supplier_order_number.nil?
    hash[:supplier_code]                = @supplier_code                    unless @supplier_code.nil?
    hash[:ship_to_store_code]           = @ship_to_store_code               unless @ship_to_store_code.nil?
    hash[:invoice_to_store_code]        = @invoice_to_store_code            unless @invoice_to_store_code.nil?

    hash[:line_items]                   = @line_items.map(&:to_eancom)      unless @line_items.nil? || @line_items.size < 1

    hash[:charge_amount]                = @charge_amount                    unless @charge_amount.nil?
    hash[:total_invoice_amount]         = @total_invoice_amount             unless @total_invoice_amount.nil?
    hash[:total_line_items_amount]      = @total_line_items_amount          unless @total_line_items_amount.nil?
    hash[:invoice_amount]               = @invoice_amount                   unless @invoice_amount.nil?
    hash[:total_message_amount]         = @total_message_amount             unless @total_message_amount.nil?
    hash[:tax_amount]                   = @tax_amount                       unless @tax_amount.nil?
    hash[:taxable_amount]               = @taxable_amount                   unless @taxable_amount.nil?
    hash[:total_amount]                 = @total_amount                     unless @total_amount.nil?
    hash[:total_discountable_amount]    = @total_discountable_amount        unless @total_discountable_amount.nil?
    hash[:total_charges_amount]         = @total_charges_amount             unless @total_charges_amount.nil?
    hash[:total_discount_amount]        = @total_discount_amount            unless @total_discount_amount.nil?
    hash[:total_tax_amount]             = @total_tax_amount                 unless @total_tax_amount.nil?
    hash[:line_item_amount]             = @line_item_amount                 unless @line_item_amount.nil?

    hash
  end

end