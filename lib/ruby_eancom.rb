require 'ruby_eancom/version'
require 'edi4r'
require 'edi4r/edifact'

require 'ruby_eancom/purchase_order'
require 'ruby_eancom/purchase_order_line'

require 'ruby_eancom/mapper'
require 'ruby_eancom/mapper/purchase_order'

module EANCOM

  def self.open(file, as_hash=false)
    EANCOM::Mapper.open(file, as_hash)
  end

  def self.phase(string, as_hash=false)
    EANCOM::Mapper.phase(string, as_hash)
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :charset,
                  :message_version,
                  :message_release,
                  :message_resp_agency,
                  :message_assigned_code,
                  :purchase_order_class

    def initialize
      @charset = 'UNOA'
      @message_version = 'D'
      @message_release = '96A'
      @message_resp_agency = 'UN'
      @message_assigned_code = 'EAN008'
      @purchase_order_class = EANCOM::PurchaseOrder
    end
  end

  self.configuration ||= Configuration.new

end
