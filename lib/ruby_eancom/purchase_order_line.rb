class EANCOM::PurchaseOrderLine

  attr_accessor :line_number,
                :gtin,
                :product_identifier,
                :quantity,
                :price

  def from_eancom hash
    @line_number          = hash[:line_number]          unless hash[:line_number].nil?
    @gtin                 = hash[:gtin]                 unless hash[:gtin].nil?
    @product_identifier   = hash[:product_identifier]   unless hash[:product_identifier].nil?
    @quantity             = hash[:quantity]             unless hash[:quantity].nil?
    @price                = hash[:price]                unless hash[:price].nil?
  end

  def to_eancom
    {
        line_number: @line_number,
        gtin: @gtin,
        product_identifier: @product_identifier,
        quantity: @quantity,
        price: @price
    }
  end

end