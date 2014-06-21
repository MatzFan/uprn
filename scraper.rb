require 'mechanize'

class Scraper

  URL = 'https://www.dataprotection.gov.je/cms/Notification/'
  ID_FIELD = :'_ctl0:cphContent:InitialPage:txt_company_id'
  CODE_FIELD = :'_ctl0:cphContent:InitialPage:txt_security_code'

  def initialize
    @agent = Mechanize.new
  end

  def get_login_page_source(company_id, code)
    login_page = @agent.get(URL)
    login_form = login_page.form('aspnetForm')
    login_form.send(ID_FIELD,company_id) # use send as method (form field) name can be arbitrary string
    login_form.send(CODE_FIELD, code) # ditto
    page = @agent.submit(login_form, login_form.buttons.first).body
  end

end
