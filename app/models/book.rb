class Book
  include DbConnected

  TOTAL_BOOKS = 66

  def get_random_book
    1 + rand( TOTAL_BOOKS )
  end

  def get_book( book_id )
    @db.get_first_row( "select \"name\" from books where book_id = :book_id", :book_id => book_id )[0]
  end

  def get_book_by_name( name )
    @db.get_first_row( "select \"id\" from books where name = :name", :name => name.capitalize )[0]
  end
end