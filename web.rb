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

get '/locations_for' do
  @locations = [@mech.to_s]
  # search_string = params[:search_string]
  # scraper = Scraper.new(@mech, @page, search_string)
  # @locations = scraper.addresses
  erb :locations_for
end

