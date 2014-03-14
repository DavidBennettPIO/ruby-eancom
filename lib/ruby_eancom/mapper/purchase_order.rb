require 'ruby_eancom'
require 'ruby_eancom/mapper'
require 'ruby_eancom/mapper/from_segment'
require 'ruby_eancom/mapper/to_segment'

class EANCOM::Mapper::PurchaseOrder

  def self.phase msg, opts

    seg_map = EANCOM::Mapper::FromSegment.new(msg, opts, :purchase_order)
    po = seg_map.phase

    if opts[:as_hash]
      return po
    else
      poc = EANCOM.configuration.purchase_order_class.new
      poc.from_eancom(po)
      return poc
    end

  end

  def self.build(ic, opts, hash)

    msg = ic.new_message(opts.merge({msg_type: 'ORDERS'}))

    seg_map = EANCOM::Mapper::ToSegment.new(msg, opts, hash, :purchase_order)
    seg_map.build

    puts msg
    ic.add(msg)

  end

end