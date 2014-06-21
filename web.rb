require 'sinatra'
require 'slim'
require_relative './scraper'

get '/' do
  s = Scraper.new
  s.get_login_page_source('19961', 'e6m6h6')
end
