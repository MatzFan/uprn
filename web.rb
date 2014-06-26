require 'sinatra'
require_relative './scraper'

get '/' do
  @mech = Mechanizer.new
  @page = @mech.get_page_6
  'done'
end

post '/num_locations' do
  search_string = params[:search_string]
  scraper = Scraper.new(search_string)
  @num_addresses = scraper.num_locations
  erb :num_addresses
end

post '/locations' do
  search_string = params[:search_string]
  @locations = search_string
  # scraper = Scraper.new(@mech, @page, search_string)
  # addresses = scraper.addresses
  # @addresses = parsed_addresses.join('^')
  erb : :locations
end

