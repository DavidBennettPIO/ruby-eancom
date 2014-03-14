require 'ruby_eancom'
require 'ruby_eancom/mapper'
require 'ruby_eancom/mapper/from_segment'
require 'ruby_eancom/mapper/to_segment'

class EANCOM::Mapper::Invoice

  def self.phase(msg, opts)

    seg_map = EANCOM::Mapper::FromSegment.new(msg, opts, :invoice)
    inv = seg_map.phase

    if opts[:as_hash]
      return inv
    else
      invc = EANCOM.configuration.invoice_class.new
      invc.from_eancom(inv)
      return invc
    end

  end

  def self.build(ic, opts, hash)

    msg = ic.new_message(opts.merge({msg_type: 'INVOIC'}))

    seg_map = EANCOM::Mapper::ToSegment.new(msg, opts, hash, :invoice)
    seg_map.build

    puts msg
    ic.add(msg)

  end

end