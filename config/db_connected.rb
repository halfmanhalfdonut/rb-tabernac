module DbConnected
  def initialize
    @db = Database.instance.get_db
  end
end