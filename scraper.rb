require 'mechanize'

class Scraper

  ID = '19961'
  CODE = 'e6m6h6'
  URL = 'https://www.dataprotection.gov.je/cms/Notification/'
  ID_FIELD = :'_ctl0:cphContent:InitialPage:txt_company_id'
  CODE_FIELD = :'_ctl0:cphContent:InitialPage:txt_security_code'
  ADDRESS_SEARCH_TXT_FIELD = :'_ctl0:cphContent:CompanyDetail:lpi_contact_address:txt_search'
  RESULTS_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_lb_results'
  RESULTS_FIELD = '_ctl0:cphContent:CompanyDetail:lpi_contact_address:lb_results'
  ADDRESS_ID = '_ctl0_cphContent_CompanyDetail_lpi_contact_address_txt_address'
  FORM = 'aspnetForm'

  def initialize
    @agent = Mechanize.new
  end

  def get_login_page
    login_page = @agent.get(URL)
    form = login_page.form(FORM)
    form.send(ID_FIELD, ID) # use send as method (form field) name can be arbitrary string
    form.send(CODE_FIELD, CODE) # ditto
    @agent.submit(form, form.buttons.first)
  end

  def get_page_5
    form = get_login_page.form(FORM)
    @agent.submit(form, form.buttons.last)
  end

  def get_page_6
    form = get_page_5.form(FORM)
    @agent.submit(form, form.buttons.last)
  end

  def results_page(search_string)
    form = get_page_6.form(FORM)
    form.send(ADDRESS_SEARCH_TXT_FIELD, search_string)
    @agent.submit(form, form.buttons.first)
  end

  def get_uprns(results_page)
    results_page.search('select#' + RESULTS_ID).css('option').map do |e|
      e.attribute('value').content
    end
  end

  def get_address(results_page, num)
    form = results_page.form(FORM)
    form.field_with(name: RESULTS_FIELD).options[num].select
    # new line simulates JS postback 'onChange'
    form.add_field!('__EVENTTARGET', RESULTS_FIELD.gsub(':', '$'))
    @agent.submit(form).search('#'+ADDRESS_ID).children.to_s.gsub("\r\n", ', ')
  end

  def get_addresses_for(search_string)
    results = results_page(search_string)
    addresses = get_uprns(results)
    addresses.map { |add| add << get_address(results, addresses.index(add)) }
  end

end
