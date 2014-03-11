require 'ruby_eancom'
require 'ruby_eancom/mapper'

class EANCOM::Mapper::PurchaseOrder

  # Class Methods

  def self.phase msg, opts

    is_d96a = opts[:release] == '96A'

    po = {type: :purchase_order}

    msg.find_all {|seg| ['BGM', 'DTM', 'NAD'].include?(seg.name) }.each do |seg|

      case seg.name
        when 'BGM'
          #puts seg.inspect
          bgm = msg['BGM'].first
          po[:order_number] = is_d96a ? bgm.d1004 : bgm.cC106.d1004

        when 'DTM'

          case seg.cC507.d2005.to_i
            when 137
              po[:order_date] = Date.strptime(seg.cC507.d2380, '%Y%m%d')
            when 2
              po[:requested_delivery_date] = Date.strptime(seg.cC507.d2380, '%Y%m%d')
            else
              raise "Segment DTM+#{seg.cC507.d2005}: Not accounted for!"
          end

        when 'NAD'
          #puts seg.inspect
          case seg.d3035
            when 'SU'
              po[:supplier_code] = seg.cC082.d3039
            when 'ST'
              po[:ship_store_code] = seg.cC082.d3039
            when 'IV'
              po[:invoice_store_code] = seg.cC082.d3039
            else
              raise "Segment NAD+#{seg.d3035}: Not accounted for!"
          end

        else
          raise "Unsupported segment/group: #{seg.name}!"
      end

    end

    po[:line_items] ||= []

    msg.find_all {|seg| seg.name=='LIN'}.each do |lin|

      pol = {}

      lin.descendants_and_self.each do |seg|
        # puts seg.inspect
        case seg.name
          when 'LIN'
            # puts seg.inspect
            pol[:line_number] = seg.d1082
            pol[:gtin] = seg.cC212.d7140 unless seg.cC212.d7140.nil?
          when 'PIA'
            pol[:product_identifier] = seg.aC212.first.d7140
          when 'QTY'
            pol[:quantity] = seg.cC186.d6060
          when 'PRI'
            pol[:price] = seg.cC509.d5118
        end

      end

      po[:line_items] << pol

    end

    # puts msg['CNT'].inspect

    po

  end

  def self.build(poc, ic, opts)

    is_d96a = opts[:release] == '96A'

    msg = ic.new_message(
        msg_type: 'ORDERS',
        version: opts[:version],
        release: opts[:release],
        resp_agency: opts[:resp_agency],
        assigned_code: opts[:assigned_code]
    )

    po = poc.to_eancom

    unless po[:order_number].nil?
      bgm = msg.new_segment( 'BGM' )
      if is_d96a
        bgm.d1004 = po[:order_number]
      else
        bgm.cC106.d1004 = po[:order_number]
      end
      bgm.cC002.d1001 = 220
      bgm.d1225 = is_d96a ? 92 : 9
      #puts bgm.inspect
      msg.add(bgm)
    end

    unless po[:order_date].nil?
      dtm = msg.new_segment( 'DTM' )
      dtm.cC507.d2380 = po[:order_date].strftime('%Y%m%d')
      dtm.cC507.d2005 = 137
      dtm.cC507.d2379 = 102
      #puts dtm.inspect
      msg.add(dtm)
    end

    unless po[:requested_delivery_date].nil?
      dtm = msg.new_segment( 'DTM' )
      dtm.cC507.d2380 = po[:requested_delivery_date].strftime('%Y%m%d')
      dtm.cC507.d2005 = 2
      dtm.cC507.d2379 = 102
      #puts dtm.inspect
      msg.add(dtm)
    end

    unless po[:supplier_code].nil?
      nad = msg.new_segment( 'NAD' )
      nad.cC082.d3039 = po[:supplier_code]
      nad.cC082.d3055 = is_d96a ? 92 : 9
      nad.d3035 = 'SU'
      #puts nad.inspect
      msg.add(nad)
    end

    unless po[:ship_store_code].nil?
      nad = msg.new_segment( 'NAD' )
      nad.cC082.d3039 = po[:ship_store_code]
      nad.cC082.d3055 = is_d96a ? 92 : 9
      nad.d3035 = 'ST'
      #puts nad.inspect
      msg.add(nad)
    end

    unless po[:invoice_store_code].nil?
      nad = msg.new_segment( 'NAD' )
      nad.cC082.d3039 = po[:invoice_store_code]
      nad.cC082.d3055 = is_d96a ? 92 : 9
      nad.d3035 = 'IV'
      #puts nad.inspect
      msg.add(nad)
    end

    unless po[:line_items].nil?
      po[:line_items].each_with_index do |li, i|

        lin = msg.new_segment( 'LIN' )
        lin.d1082 = i+1
        lin.cC212.d7140 = li[:gtin] unless li[:gtin].nil?
        lin.cC212.d7143 = 'SRV' unless li[:gtin].nil?
        # puts lin.inspect
        msg.add(lin)

        unless li[:product_identifier].nil?
          pia = msg.new_segment( 'PIA' )
          pia.d4347 = 5
          pia.aC212[0].d7140 = li[:product_identifier]
          # TODO config?
          pia.aC212[0].d7143 = is_d96a ? 'VN' : 'SA'
          pia.aC212[0].d3055 = 91 if is_d96a
          #puts pia.inspect
          msg.add(pia)
        end

        qty = msg.new_segment( 'QTY' )
        qty.cC186.d6063 = 21
        qty.cC186.d6060 = li[:quantity]
        # TODO config?
        qty.cC186.d6411 = 'EA' if is_d96a
        #puts qty.inspect
        msg.add(qty)

        pri = msg.new_segment( 'PRI' )
        pri.cC509.d5125 = 'AAA'
        pri.cC509.d5118 = li[:price]
        # TODO config?
        pri.cC509.d5387 = 'TU'
        #puts pri.inspect
        msg.add(pri)

      end

      uns = msg.new_segment( 'UNS' )
      uns.d0081 = 'S'
      #puts uns.inspect
      msg.add(uns)

      unless po[:line_items].nil?
        cnt = msg.new_segment( 'CNT' )
        cnt.cC270.d6069 = 2
        cnt.cC270.d6066 = po[:line_items].size
        #puts cnt.inspect
        msg.add(cnt)
      end

    end



    msg

  end

end