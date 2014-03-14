require 'ruby_eancom'
require 'ruby_eancom/purchase_order'
require 'ruby_eancom/invoice'

class EANCOM::Configuration

  attr_accessor :charset,
                :message_version,
                :message_release,
                :message_resp_agency,
                :message_assigned_code,
                :purchase_order_class,
                :invoice_class

  def initialize
    @charset = 'UNOA'
    @message_version = 'D'
    @message_release = '96A'
    @message_resp_agency = 'UN'
    @message_assigned_code = 'EAN008'
    @purchase_order_class = EANCOM::PurchaseOrder
    @invoice_class = EANCOM::Invoice
  end

end
