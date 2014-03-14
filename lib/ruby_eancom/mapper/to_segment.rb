class EANCOM::Mapper::ToSegment

  def initialize(msg, opts, hash, type=nil)
    @is_d96a = (opts[:release] == '96A')
    @msg = msg
    @opts = opts
    @hash = hash
    @type = type
    @line_item = type == :line_item
  end

  def build

    @hash.each do |key, value|

      case key

        # BGM Numbers
        when :order_number
          self.bgm(220, value, @hash[:document_name])
        when :invoice_number
          self.bgm(388, value, @hash[:document_name])

        # DTM Dates
        when :requested_delivery_date
          self.dtm(2, value)
        when :invoice_date
          self.dtm(3, value)
        when :order_date
          self.dtm(4, value)
        when :terms_due_date
          self.dtm(13, value)
        when :message_date
          self.dtm(137, value)

        #RFF Numbers
        when :buyer_order_number
          self.rff('ON', value)
        when :supplier_order_number
          self.rff('VN', value)

        #NAD Info
        when :supplier_code
          self.nad('SU', value)
        when :ship_to_store_code
          self.nad('ST', value)
        when :invoice_to_store_code
          self.nad('IV', value)

        # Line Items
        when :line_items
          self.build_lines value

          if [:purchase_order, :invoice].include?(@type)
            self.uns('S')
          end
          self.cnt(2, value.size)

        #MAO Amounts
        when :total_amount
          self.moa(128, value)
        when :total_message_amount
          self.moa(86, value)
        when :total_invoice_amount
          self.moa(39, value)
        when :total_line_items_amount
          self.moa(76, value)
        when :total_tax_amount
          self.moa(176, value)
        when :total_discountable_amount
          self.moa(129, value)
        when :total_charges_amount
          self.moa(131, value)
        when :total_discount_amount
          self.moa(138, value)
        when :invoice_amount
          self.moa(77, value)
        when :line_item_amount
          self.moa(203, value)
        when :tax_amount
          self.moa(124, value)
        when :charge_amount
          self.moa(23, value)
        when :taxable_amount
          self.moa(125, value)
      end

    end



    @msg
  end

  def build_lines(line_items)
    line_items.each_with_index do |hash, i|

      if hash[:gtin].nil?
        self.lin(i)
      else
        self.lin(i, hash[:gtin], 'SRV')
      end

      hash.each do |key, value|
        case key
          when :supplier_product_identifier
            self.pia(5, value, 'SA')
          when :product_identifier
            self.pia(5, value, 'IN')
          when :quantity
            q = 1
            q = 21 if @type == :purchase_order
            q = 47 if @type == :invoice
            self.qty(q, value)
          when :price
            self.pri('AAA', value)

          #TAX Code
          when :duty_code
            self.tax(5, value)
          when :tax_code
            self.tax(7, value)

          #MAO Amounts
          when :invoice_amount
            self.moa(77, value)
          when :line_item_amount
            self.moa(203, value)
          when :tax_amount
            self.moa(124, value)
          when :charge_amount
            self.moa(23, value)
          when :taxable_amount
            self.moa(125, value)

        end
      end
    end
  end

  def bgm(type, number, name)
    seg = @msg.new_segment('BGM')
    if @is_d96a
      seg.d1004 = number
    else
      seg.cC106.d1004 = number
    end
    seg.cC002.d1001 = type
    seg.d1225 = 9 # @is_d96a ? 92 : 9
    seg.cC002.d1000 = name unless name.nil?
    @msg.add(seg)
  end

  def dtm(type, date)
    seg = @msg.new_segment('DTM')
    seg.cC507.d2380 = date.strftime('%Y%m%d')
    seg.cC507.d2005 = type
    seg.cC507.d2379 = 102
    @msg.add(seg)
  end

  def rff(qualifier, number)
    seg = @msg.new_segment('RFF')
    seg.cC506.d1154 = number
    # seg.cC082.d3055 = @is_d96a ? 92 : 9
    seg.cC506.d1153 = qualifier
    @msg.add(seg)
  end

  def nad(type, code)
    seg = @msg.new_segment('NAD')
    seg.cC082.d3039 = code
    seg.cC082.d3055 = @is_d96a ? 92 : 9
    seg.d3035 = type
    @msg.add(seg)
  end

  def lin(i, number=nil, type=nil)
    seg = @msg.new_segment('LIN')
    seg.d1082 = i+1
    seg.cC212.d7140 = number unless number.nil?
    seg.cC212.d7143 = type unless type.nil?
    @msg.add(seg)
  end

  def pia(qualifier, number, type)
    seg = @msg.new_segment('PIA')
    seg.d4347 = qualifier
    seg.aC212[0].d7140 = number
    seg.aC212[0].d7143 = type
    # TODO config?
    # seg.aC212[0].d3055 = 91 if @is_d96a
    @msg.add(seg)
  end

  def qty(qualifier, number)
    seg = @msg.new_segment('QTY')
    seg.cC186.d6063 = qualifier
    seg.cC186.d6060 = number
    # TODO config?
    # seg.cC186.d6411 = 'EA' if @is_d96a
    @msg.add(seg)
  end

  def pri(qualifier, number)
    seg = @msg.new_segment('PRI')
    seg.cC509.d5125 = qualifier
    seg.cC509.d5118 = number
    # TODO config?
    seg.cC509.d5387 = 'TU'
    @msg.add(seg)
  end

  def tax(qualifier, code)
    seg = @msg.new_segment('TAX')
    seg.d5283 = qualifier
    seg.cC241.d5153 = code
    @msg.add(seg)
  end

  def moa(qualifier, amount)
    seg = @msg.new_segment('MOA')
    seg.cC516.d5025 = qualifier
    seg.cC516.d5004 = amount
    @msg.add(seg)
  end

  def cnt(type, size)
    seg = @msg.new_segment('CNT')
    seg.cC270.d6069 = type
    seg.cC270.d6066 = size
    @msg.add(seg)
  end

  def uns(type)
    uns = @msg.new_segment('UNS')
    uns.d0081 = type
    @msg.add(uns)
  end

end