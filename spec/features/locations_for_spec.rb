require_relative '../spec_helper'

describe 'locations_for path' do
  describe 'GET /locations_for' do
    before { get '/locations_for?search_string=fourneaux' }

    it 'is successful' do
      expect(last_response.status).to eq 200
    end

    it 'returns "48" on the first line' do
      expect(last_response.body.split("\n").first).to eq '48'
    end

    it 'returns 48 ^-separated items on the second line' do
      expect(last_response.body.split("\n").last.split('^').size).to eq 48
    end

  end
end
