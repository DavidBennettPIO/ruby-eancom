require 'ruby_eancom/version'
require 'edi4r'
require 'edi4r/edifact'

require 'ruby_eancom/configuration'
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

  self.configuration ||= Configuration.new

end
