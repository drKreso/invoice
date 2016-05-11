#!/usr/bin/env ruby
#encoding:utf-8
require '../lib/invoice/pdf_invoice'
require 'amount_inflector'

POSTAVKE =
{
 company_info:
  {
    title: 'BLABLA d.o.o.',
    address: 'BLABLA VUKASA 68, HR-105600 Zagreb, HRVATSKA',
    numbers: 'MB 2447848, OIB 58949043560',
    vat_id: 'VAT: HR58944443560',
    account_number: 'HR1223400091512277598',
    swift: 'RZBHHR2X'
  },
 customers:
  {
    okretnica: {
            name: 'Okredsadastnica d.o.o.',
            address_street: 'Cvijdadseete Pedefrric 37', address_city: '10000 ZAGREB',
            numbers: 'OIB 83012307340'
          },
    topmalhal:
          {
            name: 'TopMalHalralsadldalda, LLC',
            address_street: '233 Ruanhasga St.',
            address_city: 'Padsalo Asdalto, CA 94301, USA',
            location: 'USA'
          }
  },
  tax: '25%',
  signature_line_1: 'Direktor "BLABLA ITS" d.o.o.',
  signature_line_2: 'Mile voli Disko',
  number_to_words_translation: NumberToKune,
  footer: "Društvo je upisano u registar Trgovačkog suda u Zagrebu pod brojem 080700909\nTemeljni kapital društva iznosi 20.000,00 kn i uplaćen je u cjelosti\nČlan Uprave Mile voli Disko zastupa društvo pojedinačno i samostalno",
  place: "Zagreb"
}


#---------DOMACA ZADNJA---------------
#  no: '3/2014/KB',
#  date: '30.06.2014',
#  customer: 'okretnica',
#  items: [
#    { description: 'DALJNJI RAZVOJ I ODRŽAVANJE APLIKACIJE', amount: 5_000.00 }
#  ]


#---------STRANA ZADNJA---------------
INVOICE={
  no: '7/2016/KB',
  date: '02.05.2016',
  customer: 'topmalhal',
  items: [
   { description: 'Usluge implementacije za razdoblje 01.04.2016-30.04.2016 (21 dan)', amount: 1_500}
  ]
}


PDFInvoice.generate(POSTAVKE, INVOICE, '~/Desktop')

puts "Faktura je uspjesno generirana"
