module Tabernac
  module Models
    class Chapter
      include Tabernac::Config::DbConnected

      def get_random_chapter( bible, book_id )
        count = @db.get_first_value( "select count( distinct \"chapter_id\" ) from #{bible} where book_id = :book_id", :book_id => book_id )
        1 + rand( count )
      end
    end
  end
end