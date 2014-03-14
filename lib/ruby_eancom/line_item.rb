class EANCOM::LineItem

  attr_accessor :line_number,
                :gtin,
                :product_identifier,
                :supplier_product_identifier,
                :quantity,
                :price,
                :duty_code,
                :tax_code,
                :charge_amount,
                :invoice_amount,
                :tax_amount,
                :taxable_amount,
                :line_item_amount

  def from_eancom hash
    @line_number                  = hash[:line_number]                  unless hash[:line_number].nil?
    @gtin                         = hash[:gtin]                         unless hash[:gtin].nil?
    @supplier_product_identifier  = hash[:supplier_product_identifier]  unless hash[:supplier_product_identifier].nil?
    @product_identifier           = hash[:product_identifier]           unless hash[:product_identifier].nil?
    @quantity                     = hash[:quantity]                     unless hash[:quantity].nil?
    @price                        = hash[:price]                        unless hash[:price].nil?
    @duty_code                    = hash[:duty_code]                    unless hash[:duty_code].nil?
    @tax_code                     = hash[:tax_code]                     unless hash[:tax_code].nil?

    @charge_amount                = hash[:charge_amount]                unless hash[:charge_amount].nil?
    @invoice_amount               = hash[:invoice_amount]               unless hash[:invoice_amount].nil?
    @tax_amount                   = hash[:tax_amount]                   unless hash[:tax_amount].nil?
    @taxable_amount               = hash[:taxable_amount]               unless hash[:taxable_amount].nil?
    @line_item_amount             = hash[:line_item_amount]             unless hash[:line_item_amount].nil?
  end

  def to_eancom
    hash = {}
    # hash[:line_number]                = @line_number                  unless @line_number.nil?
    hash[:gtin]                         = @gtin                         unless @gtin.nil?
    hash[:product_identifier]           = @product_identifier           unless @product_identifier.nil?
    hash[:supplier_product_identifier]  = @supplier_product_identifier  unless @supplier_product_identifier.nil?
    hash[:supplier_code]                = @supplier_code                unless @supplier_code.nil?
    hash[:quantity]                     = @quantity                     unless @quantity.nil?
    hash[:price]                        = @price                        unless @price.nil?
    hash[:duty_code]                    = @duty_code                    unless @duty_code.nil?
    hash[:tax_code]                     = @tax_code                     unless @tax_code.nil?

    hash[:charge_amount]                = @charge_amount                unless @charge_amount.nil?
    hash[:invoice_amount]               = @invoice_amount               unless @invoice_amount.nil?
    hash[:tax_amount]                   = @tax_amount                   unless @tax_amount.nil?
    hash[:taxable_amount]               = @taxable_amount               unless @taxable_amount.nil?
    hash[:line_item_amount]             = @line_item_amount             unless @line_item_amount.nil?

    hash
  end

end