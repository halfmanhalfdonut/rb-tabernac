require 'sqlite3'
require 'singleton'

class Database
  include Singleton

  def initialize
    @db = SQLite3::Database.new "bible-sqlite.db"
  end

  def get_db
    @db
  end
end