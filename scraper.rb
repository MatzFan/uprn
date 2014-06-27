require 'mechanize'
require_relative './mechanizer'

class Scraper

  PARISHES = %w(Grouville St.\ Brelade St.\ Clement St.\ Helier St.\ John St.\ Lawrence St.\ Martin St.\ Mary St.\ Ouen St.\ Peter St.\ Saviour Trinity)

  FORM = 'aspnetForm'
  ADDRESS_SEARCH_TXT_FIELD = :'_ctl0:cphContent:CompanyDetail:lpi_contact_address:txt_search'
  PARISH_FIELD = '_ctl0:cphContent:CompanyDetail:lpi_contact_address:drp_parish'
  RESULTS_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_lb_results'
  RESULTS_FIELD = '_ctl0:cphContent:CompanyDetail:lpi_contact_address:lb_results'
  ADDRESS_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_txt_address'
  ADDRESS_COUNT = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_lbl_count'

  attr_reader :count, :postcodes, :parishes

  def initialize(mechanizer, page, search_string, parish_num = 0)
    @mechanizer = mechanizer
    @page = page
    @search_string = search_string
    @parish_num = parish_num.to_i # 0 selects 'any parish'
    @results = get_results
    @count = count
    @short_addresses = short_addresses
  end

  def get_results #page
    form = @page.form(FORM)
    form.send(ADDRESS_SEARCH_TXT_FIELD, @search_string)
    form.field_with(name: PARISH_FIELD).options[@parish_num].select
    @mechanizer.agent.submit(form, form.buttons.first)
  end

  def short_addresses
    adds = @results.search('#' + RESULTS_ID).children.css('option').children
    adds.map { |add| add.text.strip + ' ' } # space added so split >> 3 fields always
  end

  def postcodes_and_parishes
    postcode_parishes = Array.new(count.to_i)
    field_list = @short_addresses.map { |add| add.split(',') }
    field_list.each_with_index do |add_fields, i|
      num_fields = add_fields.count
      postcode_parishes[i] = [add_fields.last.strip, add_fields[num_fields - 2].strip]
    end
    postcode_parishes
  end

  def count
    @results.search('#' + ADDRESS_COUNT).children.to_s.split(' ')[0]
  end

  def get_uprns
    @results.search('#' + RESULTS_ID).css('option').map do |e|
      e.attribute('value').content
    end
  end

  def get_address(num)
    form = @results.form(FORM)
    form.field_with(name: RESULTS_FIELD).options[num].select
    form.add_field!('__EVENTTARGET', RESULTS_FIELD.gsub(':', '$'))
    postback_page = @mechanizer.agent.submit(form)
    postback_page.search('#' + ADDRESS_ID).children.to_s.gsub("\r\n", '|')
  end

  def addresses
    addresses = get_uprns
    adds = addresses.map { |add| add << get_address(addresses.index(add)) }
  end

end

m = Mechanizer.new
page_6 = m.get_page_6
s = Scraper.new(m, page_6, 'crabbe')
puts s.short_addresses
p s.postcodes_and_parishes
