require 'sqlite3'
require 'singleton'

class Database
  include Singleton

  def initialize
    @db = SQLite3::Database.new ENV["TABERNAC_DB"]
  end

  def get_db
    @db
  end
end
