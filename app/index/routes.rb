# No params sent in, return a random bible/chapter/verse
def randomize
  bible = Bible.new
  random_bible = bible.get_random_bible
  bible_table = random_bible[:table]

  book = Book.new
  book_id = book.get_random_book
  book_name = book.get_book( book_id )

  chapter = Chapter.new
  chapter_id = chapter.get_random_chapter( bible_table, book_id )

  verse = Verse.new
  verse_id = verse.get_random_verse( bible_table, book_id, chapter_id )
  verse_text = verse.get_verse( bible_table, book_id, chapter_id, verse_id )

  JSON.generate "#{random_bible[:version]} † #{book_name} #{chapter_id}:#{verse_id} † #{verse_text}"
end

get '/' do
  randomize
end

not_found do
  randomize
end