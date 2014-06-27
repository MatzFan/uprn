require 'sinatra'
require_relative './scraper'

get '/' do
  'working'
end

post '/locations_for' do
  mech = Mechanizer.new
  page_6 = mech.get_page_6
  search_string = params[:search_string]
  scraper = Scraper.new(mech, page_6, search_string)
  scraper.count < 51 ? @locations = scraper.addresses.join('^') : search_string
  erb :locations_for
end

