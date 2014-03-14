class EANCOM::Mapper::FromSegment

  def initialize(msg, opts, type=nil)
    @is_d96a = (opts[:release] == '96A')
    @msg = msg
    @opts = opts
    @hash = {}
    @hash[:type]= type unless type.nil?
    @type = type
  end

  def phase

    @msg.find_all { |seg| seg.level < 2 }.each do |seg|
      case seg.name
        when 'BGM'
          self.bgm(seg)
        when 'DTM'
          self.dtm(seg)
        when 'RFF'
          self.rff(seg)
        when 'NAD'
          self.nad(seg)
        when 'LIN'
          self.phase_lines(seg)
        when 'UNS'
          self.uns(seg)
        when 'CNT'
          self.cnt(seg)
        when 'MOA'
          self.moa(seg)
        else
          raise "Unsupported segment: #{seg.name}!"
      end
    end

    @hash
  end

  def phase_lines(seg)

    @object_hash = @hash
    @hash = {}

    seg.descendants_and_self.each do |seg|
      case seg.name
        when 'LIN'
          self.lin(seg)
        when 'PIA'
          self.pia(seg)
        when 'QTY'
          self.qty(seg)
        when 'PRI'
          self.pri(seg)
        when 'TAX'
          self.tax(seg)
        when 'MOA'
          self.moa(seg)
        else
          raise "Unsupported segment: #{seg.name}!"
      end
    end

    @object_hash[:line_items] ||= []
    @object_hash[:line_items] << @hash

    @hash = @object_hash

  end

  def bgm(seg)
    number = @is_d96a ? seg.d1004 : seg.cC106.d1004
    case seg.cC002.d1001.to_i
      when 220
        @hash[:order_number] = number
      when 388
        @hash[:invoice_number] = number
      else
        raise "Segment BTM+#{seg.cC002.d1001} not accounted for!"
    end
    @hash[:document_name] = seg.cC002.d1000 unless seg.cC002.d1001.nil?
  end

  def dtm(seg)
    date = seg.cC507.d2380

    case seg.cC507.d2379.to_i
      when 101
        date = Date.strptime(date, '%y%m%d')
      when 102
        date = Date.strptime(date, '%Y%m%d')
    end

    case seg.cC507.d2005.to_i
      when 2
        @hash[:requested_delivery_date] = date
      when 3
        @hash[:invoice_date] = date
      when 4
        @hash[:order_date] = date
      when 13
        @hash[:terms_due_date] = date
      when 137
        @hash[:message_date] = date
      else
        raise "Segment DTM+#{seg.cC507.d2005} not accounted for!"
    end
  end

  def rff(seg)
    # puts seg.inspect
    case seg.cC506.d1153
      when 'ON'
        @hash[:buyer_order_number] = seg.cC506.d1154
      when 'VN'
        @hash[:supplier_order_number] = seg.cC506.d1154
      else
        raise "Segment RFF+#{seg.cC506.d1153}: Not accounted for!"
    end
  end

  def nad(seg)
    case seg.d3035
      when 'SU'
        @hash[:supplier_code] = seg.cC082.d3039
      when 'ST'
        @hash[:ship_to_store_code] = seg.cC082.d3039
      when 'IV'
        @hash[:invoice_to_store_code] = seg.cC082.d3039
      else
        raise "Segment NAD+#{seg.d3035}: Not accounted for!"
    end
  end

  def lin(seg)
    @hash[:line_number] = seg.d1082
    @hash[:gtin] = seg.cC212.d7140 unless seg.cC212.d7140.nil?
  end

  def pia(seg)
    # puts seg.inspect
    c212 = seg.aC212.first
    case c212.d7143
      when 'VN', 'SA'
        @hash[:supplier_product_identifier] = c212.d7140
      when 'IN'
        @hash[:product_identifier] = c212.d7140
      else
        raise "Segment PIA+?+?:#{c212.d7143}: Not accounted for!"
    end
  end

  def qty(seg)
    @hash[:quantity] = seg.cC186.d6060
  end

  def pri(seg)
    @hash[:price] = seg.cC509.d5118
  end

  def tax(seg)
    # puts seg.inspect
    case seg.d5283.to_i
      when 5
        @hash[:duty_code] = seg.cC241.d5153
      when 7
        @hash[:tax_code] = seg.cC241.d5153
      else
        raise "Segment TAX+#{seg.c5283}: Not accounted for!"
    end
  end

  def moa(seg)
    case seg.cC516.d5025.to_i
      when 23
        @hash[:charge_amount] = seg.cC516.d5004
      when 39
        @hash[:total_invoice_amount] = seg.cC516.d5004
      when 76
        @hash[:total_line_items_amount] = seg.cC516.d5004
      when 77
        @hash[:invoice_amount] = seg.cC516.d5004
      when 86
        @hash[:total_message_amount] = seg.cC516.d5004
      when 124
        @hash[:tax_amount] = seg.cC516.d5004
      when 125
        @hash[:taxable_amount] = seg.cC516.d5004
      when 128
        @hash[:total_amount] = seg.cC516.d5004
      when 129
        @hash[:total_discountable_amount] = seg.cC516.d5004
      when 131
        @hash[:total_charges_amount] = seg.cC516.d5004
      when 138
        @hash[:total_discount_amount] = seg.cC516.d5004
      when 176
        @hash[:total_tax_amount] = seg.cC516.d5004
      when 203
        @hash[:line_item_amount] = seg.cC516.d5004
      else
        raise "Segment MOA+#{seg.cC516.d5025}: Not accounted for!"
    end
  end

  def cnt(seg)
    if @hash[:line_items].size != seg.cC270.d6066.to_i
      raise "Incorrect number of lines: #{hash[:line_items].size} expected #{seg.cC270.d6066.to_i}!"
    end
  end

  def uns(seg)
    if seg.d0081 != 'S'
      raise "Incorrect value of UNS: #{seg.d0081}!"
    end
  end

end