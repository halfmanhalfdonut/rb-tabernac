class Verse
  include DbConnected

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
    if end_verse_id
      range = (start_verse_id .. end_verse_id).to_a.join(", ")
    else
      range = start_verse_id
    end

    @db.execute( "select \"text\" from #{bible} where book_id = :book_id and chapter_id = :chapter_id and verse_id in (:range)",
      :book_id => book_id,
      :chapter_id => chapter_id,
      :range => range
    ) do |row, index|
      verses.push {
        :verse => range[index],
        :text => row[0]
      }
    end

    verses
  end
end