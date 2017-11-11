require 'rubygems'
require 'sinatra'
require_relative 'config/database'

set(:token) do |value|
  condition do
    puts value
  end
end

# Require all models
require_relative 'app/models/db_connected'
Dir[ './app/models/**/*.rb' ].reject { |f| f[ '/app/models/db_connected.rb' ] }.each do |file|
  puts "Loading model: #{file}"
  require file
end

# Require any controllers and routes
Dir[ './app/**/*.rb' ].reject { |f| f['/app/models'] }.each do |file|
  puts "Loading file: #{file}"
  require file
end
