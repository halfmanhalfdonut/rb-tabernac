require 'rubygems'
require 'sinatra/base'

# set up all the stuff we need to load (like models/controllers, etc)
require_relative 'bootstrap'

class App < Sinatra::Base
  get '/' do
    IndexController.instance.randomize
  end

  post '/praise-him', &PraiseHimController.instance.handle

  not_found do
    status 404
    "Not found"
  end

  # $0 is the executed file
  # __FILE__ is the current file
  run! if __FILE__ == $0
end
