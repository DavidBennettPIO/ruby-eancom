class EANCOM::PurchaseOrderLine

  attr_accessor :line_number,
                :product_identifier,
                :quantity,
                :price

  def from_eancom hash
    self.line_number          = hash[:line_number]          unless hash[:line_number].nil?
    self.product_identifier   = hash[:product_identifier]   unless hash[:product_identifier].nil?
    self.quantity             = hash[:quantity]             unless hash[:quantity].nil?
    self.price                = hash[:price]                unless hash[:price].nil?
  end

  def to_eancom
    {
        line_number: self.line_number,
        product_identifier: self.product_identifier,
        quantity: self.quantity,
        price: self.price
    }
  end

end