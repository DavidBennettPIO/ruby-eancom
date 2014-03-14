# Ruby EANCOM

This gem can translate GS1 EANCOM data between UN/EDIFACT and ruby hashes/classes.

Currently these messages/classes are supported:

* ORDERS <=> PurchaseOrder
* INVOIC <=> Invoice

These are marked as TODO:

* ORDCHG <=> PurchaseOrderChangeRequest
* ORDRSP <=> PurchaseOrderResponse

Both `D.96A` and `D.01B` are supported.

Feel free to submit issues and/or pull requests for fixes and extra functionality.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-eancom', github: 'complistic-gaff/ruby-eancom'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-eancom

## Configuration

You can change setting using the configure block like so:

    EANCOM.configure do |config|
      config.message_assigned_code = 'EAN008'
    end

Here is a list of options with there default values:

    charset = 'UNOA'
    message_version = 'D'
    message_release = '96A'
    message_resp_agency = 'UN'
    message_assigned_code = 'EAN008'
    purchase_order_class = EANCOM::PurchaseOrder

## Usage

### Translate UN/EDIFACT into ruby classes

From a file:

    >> EANCOM.open('order.edi')
    => [#<EANCOM::PurchaseOrder @order_number="10910220", ... @line_items=[#<EANCOM::PurchaseOrderLine @quantity=10 ...>]>]

From a string:

    >> EANCOM.phase("UNA:+.? 'UNB+UNOA:3+1:ZZ+...+ORDERS:D:96A:UN:EAN008...")
    => [#<EANCOM::PurchaseOrder @order_number="10910220", ... @line_items=[#<EANCOM::PurchaseOrderLine @quantity=10 ...>]>]

The return value is always an array with one ruby class per UN/EDIFACT message.

### Translate UN/EDIFACT into ruby hashes

Same as above but with the second parameter set to `true`.

    >> EANCOM.open('order.edi', true)
    => [{:order_number="10910220", ... :line_items=[{:quantity=10 ...}]}]

This may be faster then a class as it skips the class mapping.

### Translate ruby classes into UN/EDIFACT

    >> EANCOM.build([#<EANCOM::PurchaseOrder ...>])
    => "UNA:+.? 'UNB+UNOA:3+1:ZZ+...+ORDERS:D:96A:UN:EAN008..."

The build method takes an array of ruby classes and creates one UN/EDIFACT message per class.

### Using your own classes

You can use your own classes if they respond to the `from_eancom` and `to_eancom` methods.

Just set the class in the config like so:

    EANCOM.configure do |config|
      config.purchase_order_class = MyPurchaseOrder
    end

Have a look at the [EANCOM::PurchaseOrder](https://github.com/complistic-gaff/ruby-eancom/blob/master/lib/ruby_eancom/purchase_order.rb) class for an example of how this works.

## Contributing

1. Fork it ( http://github.com/complistic-gaff/ruby_eancom/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
