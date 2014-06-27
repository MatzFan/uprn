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
  @locs = case scraper.count
  when '0'
    '0'
  when 'More'
    '>50'
  else
    scraper.addresses.join('^')
  end
  erb :locations_for
end

