#encoding: utf-8
require 'prawn'
require 'barby'
require 'barby/outputter/prawn_outputter'
require 'barby/barcode/code_39'
require 'date'
require 'action_view'

class CroatianPDFInvoice < Prawn::Document
  include ActionView::Helpers::NumberHelper
  extend ActionView::Helpers::NumberHelper

  def self.generate(settings, invoice, path)
   File.open(File.expand_path(path) + "/rn_#{invoice[:no].gsub('/','_')}_#{invoice[:customer]}.pdf", 'w') do |file|
     file.write CroatianPDFInvoice.new(settings, invoice).render
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
    add_footer
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
          text "Račun broj: #{invoice_no}", :style => :bold, :size => 15
          move_down 25
          text "Kupac:", :style => :bold
          move_up 9
          indent 150, 15 do
            text customer[:name], :style => :bold
            text customer[:address_street], :style => :bold
            text customer[:address_city], :style => :bold
            text customer[:numbers], :style => :bold
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
          text "UKUPNO", :style => :bold
          move_up 9
          ukupno = items.map { |item| item[:amount] }.reduce(:+)
          tax_amount = ukupno * (BigDecimal.new(@data[:tax].gsub('%',''))/100.0).round(2)
          total = (tax_amount + ukupno).round(2)
          text "#{to_currency(ukupno)}", :align => :right
          move_down 10
          text "PDV #{@data[:tax]}", :style => :bold
          move_up 9
          text "#{to_currency(tax_amount)}", :align => :right
          move_down 15
          stroke_horizontal_rule
          move_down 5
          text "Sveukupno za platiti:"
          move_up 9
          text "#{to_currency(total)}", :align => :right , :style => :bold
          move_down 3
          text "Slovima: #{NumberToKune.convert(total)}", :font_size => 7
          move_down 5
          stroke_horizontal_rule
          move_down 25
          text "Žiro-račun: #{@invoice[:bank_number]}"
          move_down 4
          text "Poziv na broj: #{@invoice[:reference_number]}"
          move_down 25
          text "Račun je izrađen na računalu i pravovaljan je bez potpisa i žiga", :style => :bold
          move_up 9
          text "#{@data[:signature_line_1]}", :style => :bold, :align => :right
          move_down 10
          text "#{@data[:signature_line_2]}", :style => :bold, :align => :right

        end
      end
  end

  def add_footer
    bounding_box [bounds.left, bounds.bottom + 12], :width  => bounds.width do
      move_down(5)
      text "#{footer}", :size => 7
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

  def footer
    @data[:footer]
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

  def to_currency(amount)
    return '' if amount.nil?
    "#{number_with_precision(amount, :precision => 2, :delimiter => '.', :separator => ',')} kn"
  end

end
