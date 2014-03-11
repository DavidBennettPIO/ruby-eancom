# Ruby EANCOM

This gem can translate GS1 EANCOM data between UN/EDIFACT and ruby hashes/classes.

Currently these messages/classes are supported:

* ORDERS <=> PurchaseOrder

These are marked as TODO:

* INVOIC <=> Invoice
* ORDCHG <=> PurchaseOrderChangeRequest
* ORDRSP <=> PurchaseOrderResponse

NOTE: For the moment only d96a is supported.

Feel free to submit issues and/or pull requests for fixes and extra functionality.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-eancom', github: 'complistic-gaff/ruby-eancom'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-eancom

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

## Contributing

1. Fork it ( http://github.com/complistic-gaff/ruby_eancom/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
