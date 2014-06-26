require 'mechanize'
require_relative './mechanizer'

class Scraper

  FORM = 'aspnetForm'
  ADDRESS_SEARCH_TXT_FIELD = :'_ctl0:cphContent:CompanyDetail:lpi_contact_address:txt_search'
  RESULTS_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_lb_results'
  RESULTS_FIELD = '_ctl0:cphContent:CompanyDetail:lpi_contact_address:lb_results'
  ADDRESS_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_txt_address'

  def initialize(mechanizer, page, search_string)
    @mechanizer = mechanizer
    @page = page
    @search_string = search_string
    @results = get_results
  end

  def get_results
    form = @page.form(FORM)
    form.send(ADDRESS_SEARCH_TXT_FIELD, @search_string)
    @mechanizer.agent.submit(form, form.buttons.first)
  end

  def get_uprns
    @results.search('select#' + RESULTS_ID).css('option').map do |e|
      e.attribute('value').content
    end
  end

  def get_address(num)
    form = @results.form(FORM)
    form.field_with(name: RESULTS_FIELD).options[num].select
    form.add_field!('__EVENTTARGET', RESULTS_FIELD.gsub(':', '$'))
    postback_page = @mechanizer.agent.submit(form)
    postback_page.search('#'+ADDRESS_ID).children.to_s.gsub("\r\n", '|')
  end

  def addresses
    addresses = get_uprns
    addresses.map { |add| add << get_address(addresses.index(add)) }
  end

end
