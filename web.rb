require 'sinatra'
require 'slim'
require_relative './scraper'

get '/' do
  s = Scraper.new
  s.get_uprns('station house')
end
