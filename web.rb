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
  count = scraper.count
  @locs = ((1..50).include? count ? scraper.addresses.join('^') : count)
  erb :locations_for
end

