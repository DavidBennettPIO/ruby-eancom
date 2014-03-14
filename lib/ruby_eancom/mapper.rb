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
      puts msg

      opts = {
          version: msg.header.cS009.d0052,
          release: msg.header.cS009.d0054,
          as_hash: as_hash
      }

      case msg.header.cS009.d0065
        when 'ORDERS'
          ret[:messages] << EANCOM::Mapper::PurchaseOrder.phase(msg, opts)
        when 'INVOIC'
          ret[:messages] << EANCOM::Mapper::Invoice.phase(msg, opts)
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

      # puts object.inspect

      # object_hash = object.is_a?(::Hash) ? object : object.to_eancom

      if object.is_a?(::Hash)
        case object[:type]
          when :purchase_order
            EANCOM::Mapper::PurchaseOrder.build(ic, opts, object)
          when :invoice
            EANCOM::Mapper::Invoice.build(ic, opts, object)
          else
            raise "Building from a hash with the type #{object[:type]} is not accounted for!"
        end
      else

        object_hash = object.to_eancom

        case object.class.to_s
          when EANCOM.configuration.purchase_order_class.to_s
            EANCOM::Mapper::PurchaseOrder.build(ic, opts, object_hash)
          when EANCOM.configuration.invoice_class.to_s
            EANCOM::Mapper::Invoice.build(ic, opts, object_hash)
          else
            raise "Building from a #{object[:type]} class is not accounted for!"
        end

      end


    end

    ic

  end

end