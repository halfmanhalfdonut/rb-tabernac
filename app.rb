require 'rubygems'
require 'sinatra/base'
require 'logger'

# set up all the stuff we need to load (like models/controllers, etc)
require_relative 'bootstrap'

class App < Sinatra::Base
  ::Logger.class_eval { alias :write :'<<' }
  access_log = "#{Dir.pwd}/logs/access.log"
  access_logger = ::Logger.new( access_log )

  error_log = "#{Dir.pwd}/logs/error.log"
  error_logger = ::File.new( error_log, "a+" )
  error_logger.sync = true

  configure do
    use ::Rack::CommonLogger, access_logger
    enable :logging
  end

  before {
    env[ "rack.errors" ] = error_logger
  }

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
