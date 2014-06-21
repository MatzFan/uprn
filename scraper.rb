require 'mechanize'

class Scraper

  URL = 'https://www.dataprotection.gov.je/cms/Notification/'
  ID_FIELD = :'_ctl0:cphContent:InitialPage:txt_company_id'
  CODE_FIELD = :'_ctl0:cphContent:InitialPage:txt_security_code'
  ADDRESS_SEARCH_TXT_FIELD = :'_ctl0:cphContent:CompanyDetail:lpi_contact_address:txt_search'
  RESULTS_CSS = 'select#_ctl0_cphContent_CompanyDetail_lpi_contact_address_lb_results'
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

  def get_uprns(search_string)
    form = get_page_6.form('aspnetForm')
    form.send(ADDRESS_SEARCH_TXT_FIELD, search_string)
    @agent.submit(form, form.buttons.first).search(RESULTS_CSS).css('option').to_s
  end

end
