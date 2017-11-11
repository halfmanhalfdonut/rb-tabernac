require 'rubygems'
require 'sinatra'
require_relative 'database'

token = "5WC1MzW7LDXEh1SzyHeve4P6"

get '/' do
  db = Database.new
  db.get_random()
end

post '/praise-him' do
  request.body.rewind
  data = JSON.parse request.body.read

  if data.token == token
    if data.text == ""
    end
  end

  res = {}

  JSON.generate res
end