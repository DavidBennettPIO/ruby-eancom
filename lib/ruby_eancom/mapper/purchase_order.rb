class EANCOM::Mapper::PurchaseOrder

  # Class Methods

  def self.phase_d96a msg, as_hash=false
    po = {}

    msg.find_all {|seg| ['BGM', 'DTM', 'NAD'].include?(seg.name) }.each do |seg|

      case seg.name
        when 'BGM'
          po[:order_number] = msg['BGM'].first.d1004

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

    msg.find_all {|seg| seg.name=='LIN' && seg.sg_name=='SG25'}.each do |lin|

      pol = {}

      lin.descendants_and_self.each do |seg|
        #puts seg.inspect
        case seg.name
          when 'LIN'
            pol[:line_number] = seg.d1082
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

    if as_hash
      return po
    else
      poc = EANCOM.configuration.purchase_order_class.new
      poc.from_eancom(po)
      return poc
    end

  end

  def self.build_d96a(poc, ic)

    msg = ic.new_message(
        msg_type: 'ORDERS',
        version: EANCOM.configuration.message_version,
        release: EANCOM.configuration.message_release,
        resp_agency: EANCOM.configuration.message_resp_agency,
        assigned_code: EANCOM.configuration.message_assigned_code
    )

    po = poc.to_eancom

    unless po[:order_number].nil?
      bgm = msg.new_segment( 'BGM' )
      bgm.d1004 = po[:order_number]
      bgm.cC002.d1001 = 220
      bgm.d1225 = 92
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
      nad.cC082.d3055 = 92
      nad.d3035 = 'SU'
      #puts nad.inspect
      msg.add(nad)
    end

    unless po[:ship_store_code].nil?
      nad = msg.new_segment( 'NAD' )
      nad.cC082.d3039 = po[:ship_store_code]
      nad.cC082.d3055 = 92
      nad.d3035 = 'ST'
      #puts nad.inspect
      msg.add(nad)
    end

    unless po[:invoice_store_code].nil?
      nad = msg.new_segment( 'NAD' )
      nad.cC082.d3039 = po[:invoice_store_code]
      nad.cC082.d3055 = 92
      nad.d3035 = 'IV'
      #puts nad.inspect
      msg.add(nad)
    end

    unless po[:line_items].nil?
      po[:line_items].each do |li|

        lin = msg.new_segment( 'LIN' )
        lin.d1082 = li[:line_number]
        #puts lin.inspect
        msg.add(lin)

        pia = msg.new_segment( 'PIA' )
        pia.d4347 = 5
        pia.aC212[0].d7140 = li[:product_identifier]
        pia.aC212[0].d7143 = 'VN'
        pia.aC212[0].d3055 = 91
        #puts pia.inspect
        msg.add(pia)

        qty = msg.new_segment( 'QTY' )
        qty.cC186.d6063 = 21
        qty.cC186.d6060 = li[:quantity]
        qty.cC186.d6411 = 'EA'
        #puts qty.inspect
        msg.add(qty)

        pri = msg.new_segment( 'PRI' )
        pri.cC509.d5125 = 'AAA'
        pri.cC509.d5118 = li[:price]
        pri.cC509.d5387 = 'TU'
        #puts pri.inspect
        msg.add(pri)

      end

      uns = msg.new_segment( 'UNS' )
      uns.d0081 = 'S'
      #puts uns.inspect
      msg.add(uns)

      cnt = msg.new_segment( 'CNT' )
      cnt.cC270.d6069 = 2
      cnt.cC270.d6066 = 1
      #puts cnt.inspect
      msg.add(cnt)

    end



    msg

  end

end