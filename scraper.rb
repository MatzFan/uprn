require 'mechanize'

class Scraper

  URL = 'https://www.dataprotection.gov.je/cms/Notification/'
  ID_FIELD = :'_ctl0:cphContent:InitialPage:txt_company_id'
  CODE_FIELD = :'_ctl0:cphContent:InitialPage:txt_security_code'
  ADDRESS_SEARCH_TXT_FIELD = :'_ctl0:cphContent:CompanyDetail:lpi_contact_address:txt_search'
  RESULTS_ID = 'select#_ctl0_cphContent_CompanyDetail_lpi_contact_address_lb_results'
  ADDRESS_ID = 'select#_ctl0_cphContent_CompanyDetail_lpi_contact_address_txt_address'
  ID = '19961'
  CODE = 'e6m6h6'

  def initialize
    @agent = Mechanize.new
  end

  def get_login_page
    login_page = @agent.get(URL)
    form = login_page.form('aspnetForm')
    form.send(ID_FIELD, ID) # use send as method (form field) name can be arbitrary string
    form.send(CODE_FIELD, CODE) # ditto
    @agent.submit(form, form.buttons.first)
  end

  def get_page_5
    form = get_login_page.form('aspnetForm')
    @agent.submit(form, form.buttons.last)
  end

  def get_page_6
    form = get_page_5.form('aspnetForm')
    @agent.submit(form, form.buttons.last)
  end

  def results_page_for(search_string)
    form = get_page_6.form('aspnetForm')
    form.send(ADDRESS_SEARCH_TXT_FIELD, search_string)
    @agent.submit(form, form.buttons.first)
  end

  def get_uprns(search_string)
    results_page_for(search_string).search(RESULTS_ID).css('option').to_s
  end

  def get_address(search_string, num)
    results_page = results_page_for(search_string)
    form = results_page.form('aspnetForm')
    form.field_with(name: '_ctl0:cphContent:CompanyDetail:lpi_contact_address:lb_results').options[num].select
    form.add_field!('__EVENTTARGET', '_ctl0$cphContent$CompanyDetail$lpi_contact_address$lb_results')
    new_page = @agent.submit(form)
    new_page.search('#_ctl0_cphContent_CompanyDetail_lpi_contact_address_txt_address').children.to_s
  end

end

s = Scraper.new
puts s.get_address('crabbe', 4)
