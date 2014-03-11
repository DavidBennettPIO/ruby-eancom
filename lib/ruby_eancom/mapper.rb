require 'ruby_eancom'

class EANCOM::Mapper

  def self.open(file, as_hash=false)
    self.phase(File.open(file), as_hash)
  end

  def self.phase(string, as_hash=false)
    ic = EDI::E::Interchange.parse(string)

    #puts ic.header.inspect

    ret = {sender_gln: ic.header.cS002.d0004, recipient_gln: ic.header.cS003.d0010, messages:[]}

    ic.each do |msg|
      # puts msg.header.inspect

      opts = {
          version: msg.header.cS009.d0052,
          release: msg.header.cS009.d0054
      }

      case msg.header.cS009.d0065
        when 'ORDERS'
          po = EANCOM::Mapper::PurchaseOrder.phase(msg, opts)
          if as_hash
            ret[:messages] <<  po
          else
            poc = EANCOM.configuration.purchase_order_class.new
            poc.from_eancom(po)
            ret[:messages] <<  poc
          end
      end
    end

    ret
  end

  def self.build(hash)
    ic = EDI::E::Interchange.new( :version => 3, :charset => EANCOM.configuration.charset )

    opts = {
        version: EANCOM.configuration.message_version,
        release: EANCOM.configuration.message_release,
        resp_agency: EANCOM.configuration.message_resp_agency,
        assigned_code: EANCOM.configuration.message_assigned_code
    }

    hash[:messages].each do |object|

      case object.class.to_s
        when EANCOM.configuration.purchase_order_class.to_s
          msg = EANCOM::Mapper::PurchaseOrder.build(object, ic, opts)
          ic.add( msg )
      end
    end

    ic

  end

end