require 'sinatra'
require_relative './scraper'

get '/' do
  'working'
end

get '/locations_for' do
  mech = Mechanizer.new
  page_6 = mech.get_page_6
  search_string = params[:search_string]
  parish_num = params[:parish_num]
  scraper = Scraper.new(mech, page_6, search_string, parish_num)
  @count = scraper.count
  @locations = scraper.addresses.join('^')
  erb :locations_for
end
