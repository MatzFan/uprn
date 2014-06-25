require 'sinatra'
require_relative './scraper'

get '/' do
  s = Scraper.new
  @addresses = s.get_addresses_for('crabbe')
  erb :addresses
end
