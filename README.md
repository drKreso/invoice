# Invoice

Print out simple invoice tailored for Croatia. You can setup your company data along with your customers with some easy settings.

After that you need to setup invoice data and render the invoice
```ruby
INVOICE = {
  no: '116/2012',
  place_and_date: 'Zagreb, 25.11.2012.godine',
  reference_number: "16-2012",
  customer: 'dinkovac',
  bank_number: '2484008-1105211111',
  items: [
    { description: 'EM-12/2011 Izrada izvješća održavanja iz aplikacije MIJAU', amount: 5_432.22 },
    { description: 'EM-012/2011 Održavanje aplikacije MIJAU ', amount: 100.00 }
  ]
}

#rendering
CroatianPDFInvoice.generate(SETTINGS, INVOICE, '~/Desktop') #settings example given below
```
![Example invoice](https://github.com/drKreso/invoice/raw/master/images/example_invoice.png)

## Installation

Add this line to your application's Gemfile:

    gem 'invoice'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install invoice

## Limitations

Only supports one page invoice.

## Usage

Example script:

```ruby
#!/usr/bin/env ruby
#encoding:utf-8
require 'invoice'
require 'amount_inflector'

SETTINGS= {
 company_info: {
                  title: 'KROKODIL ITS d.o.o. društvo s ograničenom odgovornošću - za usluge',
                  address: 'HRVOJA TURUDIĆA 55, HR-10000  Zagreb, HRVATSKA',
                  numbers: 'MB 2511611, OIB 511111112312',
                  phone: 'M: +385 94 111 7072'
                },
 customers:
  {
    why_the_lucky_stiff: {
              name: 'WHY THE LUCKY STIFF d.o.o.',
              address_street: 'I  Gnjile 18',
              address_city: '10000  ZAGREB',
              numbers: 'OIB 412121'
            },
    dinkovac: {
            name: 'Dinkovaca d.o.o.',
            address_street: 'Cvijete Zuzorić 137',
            address_city: '10000  ZAGREB',
            numbers: 'OIB 430101111212'
          }
  },
  tax: '25%',
  signature_line_1: 'Direktor "KROKODIL ITS" d.o.o.',
  signature_line_2: 'Krešimir Bojčić',
  number_to_words_translation: NumberToKune,
  footer: "©#{DateTime.now.year} Krokodil ITS d.o.o"
}

INVOICE = {
  no: '116/2012',
  place_and_date: 'Zagreb, 25.11.2012.godine',
  reference_number: "16-2012",
  customer: 'dinkovac',
  bank_number: '2484008-1105211111',
  items: [
    { description: 'EM-12/2011 Izrada izvješća održavanja iz aplikacije MIJAU', amount: 5_432.22 },
    { description: 'EM-012/2011 Održavanje aplikacije MIJAU ', amount: 100.00 }
  ]
}

CroatianPDFInvoice.generate(SETTINGS, INVOICE, '~/Desktop')
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
