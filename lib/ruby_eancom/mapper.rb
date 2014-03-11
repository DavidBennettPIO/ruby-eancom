#require 'eancom/mapper/purchase_order'
class EANCOM::Mapper

  def self.open(file, as_hash=false)
    self.phase(File.open(file), as_hash)
  end

  def self.phase(string, as_hash=false)

    ic = EDI::E::Interchange.parse(string)

    ret = []

    ic.each do |msg|
      case msg.header.cS009.d0065
        when 'ORDERS'
          ret << EANCOM::Mapper::PurchaseOrder.phase_d96a(msg, as_hash)
      end
    end

    ret
  end

  def self.build(*objects)

    ic = EDI::E::Interchange.new( :version => 3, :charset => 'UNOA' )

    objects.flatten.each do |object|

      case object.class.to_s
        when 'EANCOM::PurchaseOrder'
          msg = EANCOM::Mapper::PurchaseOrder.build_d96a(object, ic)
          ic.add( msg )
      end
    end

    ic

  end

end