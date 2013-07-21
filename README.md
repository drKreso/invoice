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

Example script(available in bin/generate_example.rb):

```ruby
#encoding:utf-8
require 'invoice'
require 'amount_inflector'

SETTINGS =
{
 company_info: {
                  title: 'KROKODIL ITS d.o.o. društvo s ograničenom odgovornošću - za usluge',
                  address: 'HRVOJA TURUDIĆA 55, HR-10000  Zagreb, HRVATSKA',
                  numbers: 'MB 2511611, OIB 511111112312',
                  phone: 'M: +385 94 111 7072',
                  account_number: 'HR3324640081405230496',
                  swift: 'RZBHHR2X'
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
            name: 'Dinkovaca Inc.',
            address_street: 'Potomac 137',
            address_city: '10000  Ney York',
            numbers: '430101111212',
            location: 'USA'  #triggers "no-vat template" (also 'CA')
          }
  },
  tax: '25%',
  signature_line_1: 'Direktor "KROKODIL ITS" d.o.o.',
  signature_line_2: 'Krešimir Bojčić',
  number_to_words_translation: NumberToKune,
  footer: "Društvo je upisano u registar Trgovačkog suda u Zagrebu pod brojem 090608470\nTemeljni kapital društva iznosi 20.000,00 kn i uplaćen je u cjelosti\nČlan Uprave Krešimir Bojčić zastupa društvo pojedinačno i samostalno"
}

INVOICE = {
  no: '116/2012/KB',
  place_and_date: 'Zagreb, 25.11.2012.godine',
  reference_number: "16-2012",
  customer: 'dinkovac',
  bank_number: '2484008-1105211111',
  items: [
    { description: 'EM-12/2011 Izrada izvješća održavanja iz aplikacije MIJAU', amount: 5_432.22 },
    { description: 'EM-012/2011 Održavanje aplikacije MIJAU ', amount: 100.00 }
  ]
}

PDFInvoice.generate(SETTINGS, INVOICE, '~/Desktop')
puts "Succefully generated on Desktop"
```

##History
1.0.3
   Added support for no-vat invoices (for location 'USA' and 'CA')
   Tweaked look and feel
   New legal text needed since July 1, 2013


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
