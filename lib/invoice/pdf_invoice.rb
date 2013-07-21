#encoding: utf-8
require 'prawn'
require 'barby'
require 'barby/outputter/prawn_outputter'
require 'barby/barcode/code_39'
require 'date'
require 'action_view'

class PDFInvoice < Prawn::Document
  include ActionView::Helpers::NumberHelper
  extend ActionView::Helpers::NumberHelper

  def self.generate(settings, invoice, path)
   File.open(File.expand_path(path) + "/rn_#{invoice[:no].gsub('/','_')}_#{invoice[:customer]}.pdf", 'w') do |file|
     file.write PDFInvoice.new(settings, invoice).render
   end

  end

  def initialize(data, invoice)
    @data = data
    @invoice = invoice
    super(:page_size => 'A4', :left_margin => 10, :right_margin => 10, :top_margin => 10)
    generate
  end

  def generate
    set_font_family
    add_header
    add_invoice_info
  end

  def add_header
    bounding_box [bounds.left, bounds.top], :width  => bounds.width do
      move_down 5
      indent 15 do
        text company_info[:title], :style => :bold, :size => 9
        text company_info[:address], :size => 8
        text company_info[:numbers], :size => 8
        text company_info[:phone], :size => 8
      end
    end

  end

  def add_invoice_info
      fill_color "f5f5f5"
      fill_rectangle [0,660], 575, 60
      fill_color "0000"
      move_down 10
      bounding_box([0,750], :width => 575, :height => 730) do
        stroke_color '0000'
        stroke_bounds
        move_down 35
        indent 0, 15 do
          text "R-1", :size => 10, :style => :bold, :align => :right
        end
        bounding_box [15, bounds.top - 15], :width => 160, :height => 35 do
          barcode = Barby::Code39.new(invoice_no)
          barcode.annotate_pdf(self, :height => 35, :width => 150)
        end
        move_down 15
        indent 15,15 do
          text "#{@invoice[:place_and_date]}", :align => :right
          move_up 13
          if export_no_vat?
            text "Invoice no. (Račun broj): #{invoice_no}", :style => :bold, :size => 15
          else
            text "Račun broj: #{invoice_no}", :style => :bold, :size => 15
          end
          move_down 25
          if export_no_vat?
            text "Issued To (Kupac):", :style => :bold
          else
            text "Kupac:", :style => :bold
          end
          move_up 9
          indent 150, 15 do
            text customer[:name], :style => :bold
            text customer[:address_street], :style => :bold
            text customer[:address_city], :style => :bold
            text customer[:numbers], :style => :bold unless customer[:numbers].nil?
          end
          move_down 40
          stroke_horizontal_rule
          move_down 5
          items.each_with_index do |item, index|
            move_down 5
            text "#{index + 1}.   #{item[:description]}"
            move_up 9
            text "#{to_currency(item[:amount])}", :align => :right
          end
          move_down 5
          stroke_horizontal_rule
          move_down 5
          if export_no_vat?
            text "TOTAL (UKUPNO)", :style => :bold
          else
            text "UKUPNO", :style => :bold
          end
          move_up 9
          ukupno = items.map { |item| item[:amount] }.reduce(:+)
          tax_amount = ukupno * (BigDecimal.new(@data[:tax].gsub('%',''))/100.0).round(2)
          tax_amount = 0 if export_no_vat?
          total = (tax_amount + ukupno).round(2)
          text "#{to_currency(ukupno)}", :align => :right
          unless export_no_vat?
            move_down 10
            text "PDV #{@data[:tax]}", :style => :bold
            move_up 9
            text "#{to_currency(tax_amount)}", :align => :right
          end
          move_down 15
          stroke_horizontal_rule
          move_down 5
          if export_no_vat?
            text "Total Amount (Sveukupno za platiti):"
          else
            text "Sveukupno za platiti:"
          end
          move_up 9
          text "#{to_currency(total)}", :align => :right , :style => :bold
          unless export_no_vat?
            move_down 3
            text "Slovima: #{NumberToKune.convert(total)}", :size => 7
          end
          move_down 5
          stroke_horizontal_rule
          move_down 25
          if export_no_vat?
            text "IBAN: #{company_info[:account_number]}", :style => :bold
          else
            text "Žiro-račun: #{company_info[:account_number]}"
          end
          move_down 4
          if export_no_vat?
            text "SWIFT: #{company_info[:swift]}"
          else
            text "Poziv na broj: #{@invoice[:no].gsub('/','-').gsub('-KB','')}"
          end
          move_down 4
          if export_no_vat?
            text "Payement type: bank wire (Način plaćanja: uplatom na žiro-račun)"
          else
            text "Način plaćanja: uplatom na žiro-račun"
          end
          move_down 35
          text "#{@data[:signature_line_1]}", :style => :italic, :align => :left
          move_up 10
          indent 445 do
            text "#{@data[:signature_line_2]}", :style => :bold, :align => :left
          end
          stroke do
            horizontal_line(430, 540, :at => y - 58)
          end
          move_down 25
          if export_no_vat?
            text "This is computer generated INVOICE and requires no signature or stamp (Račun je izrađen na računalu i pravovaljan je bez potpisa i žiga)", :style => :italic, :size => 7
          else
            text "Račun je izrađen na računalu i pravovaljan je bez potpisa i žiga", :style => :italic, :size => 7
          end

          # footer
          move_y = 25 + @data[:footer].split("\n").count * 9
          page_count.times do |i|
            go_to_page(i+1)
            self.font_size = 7
            bounding_box([bounds.left, bounds.bottom + move_y], :width => 550) do
              if export_no_vat?
                text "Usluga ne podliježe oporezivanju sukladno odredbi čl.5.st.6.t.2 Zakona o PDV-u.", :align => :left , :style => :italic
              else
                move_down 10
              end
              move_down 15
              @data[:footer].each_line do |line|
                text line, :style => :italic
              end
            end
            self.font_size = 9
          end
        end
      end
  end

  def items
    @invoice[:items]
  end

  def customer
    @data[:customers][@invoice[:customer].to_s.to_sym]
  end

  def company_info
    @data[:company_info]
  end

  def invoice_no
    @invoice[:no]
  end

  def set_font_family
    self.font_size = 9
    font_families.update("Verdana" => {
      :normal      =>  File.expand_path('../../../fonts/verdana.ttf', __FILE__),
      :italic      =>  File.expand_path('../../../fonts/verdanai.ttf', __FILE__),
      :bold        =>  File.expand_path('../../../fonts/verdanab.ttf', __FILE__),
      :bold_italic =>  File.expand_path('../../../fonts/verdanaz.ttf', __FILE__),
    })
    font("Verdana")
  end

  def to_d
    BigDecimal.new(self.to_s)
  end

  def to_usd_currency(amount)
    return '' if amount.nil?
    "$#{number_with_precision(amount, :precision => 2, :delimiter => '.', :separator => ',')}"
  end

  def export_no_vat?
    @data[:customers][@invoice[:customer].to_sym][:location] == 'USA' ||
    @data[:customers][@invoice[:customer].to_sym][:location] == 'CA'
  end

  def to_currency(amount)
    return to_usd_currency(amount) if export_no_vat?
    return '' if amount.nil?
    "#{number_with_precision(amount, :precision => 2, :delimiter => '.', :separator => ',')} kn"
  end

end
