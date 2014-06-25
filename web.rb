require 'sinatra'
require 'slim'
require_relative './scraper'

get '/' do
  s = Scraper.new
  # s.get_uprns('crabbe')
  s.get_address('crabbe', 4)
end
