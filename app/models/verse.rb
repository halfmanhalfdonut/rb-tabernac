module Tabernac
  module Models
    class Verse
      include Tabernac::Config::DbConnected

      def get_random_verse( bible, book_id, chapter_id )
        count = @db.get_first_value( "select count( \"verse_id\" ) from #{bible} where book_id = :book_id and chapter_id = :chapter_id",
          :book_id => book_id,
          :chapter_id => chapter_id
        )
        1 + rand( count )
      end

      def get_verse( bible, book_id, chapter_id, verse_id )
        @db.get_first_row( "select \"text\" from #{bible} where book_id = :book_id and chapter_id = :chapter_id and verse_id = :verse_id",
          :book_id => book_id,
          :chapter_id => chapter_id,
          :verse_id => verse_id
        )[0]
      end

      def get_verses( bible, book_id, chapter_id, start_verse_id, end_verse_id )
        verses = []

        stmt = ""
        if end_verse_id
          range = (start_verse_id .. end_verse_id).to_a
          range.each_with_index do |verse_id, index|
            if index == 0
              stmt = "( verse_id = #{verse_id} or "
            elsif index == range.length - 1
              stmt += "verse_id = #{verse_id} )"
            else
              stmt += "verse_id = #{verse_id} or "
            end
          end
        else
          range = [ start_verse_id ]
          stmt = "verse_id = #{start_verse_id}"
        end

        rows = @db.execute( "select \"text\" from #{bible} where book_id = :book_id and chapter_id = :chapter_id and #{stmt}",
          :book_id => book_id,
          :chapter_id => chapter_id
        )

        rows.each_with_index do |row, index|
          verses.push({
            :verse => range[index],
            :text => row[0]
          })
        end

        verses
      end
    end
  end
end