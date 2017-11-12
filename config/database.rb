require 'sqlite3'
require 'singleton'

class Database
  include Singleton

  def initialize
    connection = ENV["TABERNAC_DB"]
    @db = SQLite3::Database.new "/Users/nick/projects/www/inexact-scientist.com/tabernac/bible-sqlite.db"
  end

  def get_db
    @db
  end
end