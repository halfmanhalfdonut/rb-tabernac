require 'sqlite3'

class Database
  def initialize
    @db = SQLite3::Database.new "bible-sqlite.db"
  end

  def get_all_bibles
    bibles = {}

    @db.execute 'select "id", "table", "version" from bible_versions' do |row|
      bibles[row[0]] = {
        :table => row[1],
        :version => row[2]
      }
    end

    bibles
  end

  def get_random_bible
    bibles = get_all_bibles()
    bibles[1 + rand( bibles.length )]
  end

  def get_random_book
    1 + rand(66)
  end

  def get_book( book_id )
    @db.get_first_row( "select \"name\" from books where book_id = #{book_id}" )[0]
  end

  def get_random_chapter( bible, book_id )
    count = @db.get_first_value "select count( distinct \"chapter_id\" ) from #{bible} where book_id = #{book_id}"
    1 + rand( count )
  end

  def get_random_verse( bible, book_id, chapter_id )
    count = @db.get_first_value "select count( \"verse_id\" ) from #{bible} where book_id = #{book_id} and chapter_id = #{chapter_id}"
    1 + rand( count )
  end

  def get_verse( bible, book_id, chapter_id, verse_id )
    @db.get_first_row( "select \"text\" from #{bible} where book_id = #{book_id} and chapter_id = #{chapter_id} and verse_id = #{verse_id}" )[0]
  end

  def get_random
    bible = get_random_bible()
    puts "Bible #{bible}"
    bible_table = bible[:table]
    book_id = get_random_book()
    puts "Book ID #{book_id}"
    book = get_book( book_id )
    puts "Book #{book}"
    chapter_id = get_random_chapter( bible_table, book_id )
    puts "Chapter #{chapter_id}"
    verse_id = get_random_verse( bible_table, book_id, chapter_id )
    puts "Verse #{verse_id}"
    verse = get_verse( bible_table, book_id, chapter_id, verse_id )
    puts "Verse #{verse}"

    "#{bible[:version]} † #{book} #{chapter_id}:#{verse_id} † #{verse}"
  end
end