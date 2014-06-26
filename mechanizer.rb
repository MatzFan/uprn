require 'mechanize'

class Mechanizer

  ID = '19961'
  CODE = 'e6m6h6'
  URL = 'https://www.dataprotection.gov.je/cms/Notification/'
  ID_FIELD = :'_ctl0:cphContent:InitialPage:txt_company_id'
  CODE_FIELD = :'_ctl0:cphContent:InitialPage:txt_security_code'
  FORM = 'aspnetForm'

  attr_reader :agent

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

end

puts Mechanizer.new.to_s
