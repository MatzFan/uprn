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

post '/locations_for' do
  search_string = params[:search_string]
  scraper = Scraper.new(@mech, @page, search_string)
  raw_addresses = scraper.addresses
  # parsed_addresses = raw_addresses.map { |address| Parser.new.parse(address) }
  @addresses = parsed_addresses.join('^')
  erb :addresses
end

