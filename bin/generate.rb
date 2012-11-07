#encoding:utf-8
require './lib/invoice/croatian_pdf_invoice'
require 'amount_inflector'

SETTINGS =
{
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






