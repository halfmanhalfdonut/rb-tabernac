require 'singleton'

module Tabernac
  module Controllers
    class IndexController
      include Singleton

      def randomize
        bible = Tabernac::Models::Bible.new
        random_bible = bible.get_random_bible
        bible_table = random_bible[:table]

        book = Tabernac::Models::Book.new
        book_id = book.get_random_book
        book_name = book.get_book( book_id )

        chapter = Tabernac::Models::Chapter.new
        chapter_id = chapter.get_random_chapter( bible_table, book_id )

        verse = Tabernac::Models::Verse.new
        verse_id = verse.get_random_verse( bible_table, book_id, chapter_id )
        verse_text = verse.get_verse( bible_table, book_id, chapter_id, verse_id )

        JSON.generate({
          :response_type => "in_channel",
          :text => "Praise Him! †",
          :attachments => [
            {
              :title => random_bible[:version],
              :title_link => random_bible[:url],
              :text => "#{random_bible[:version]} † #{book_name} #{chapter_id}:#{verse_id} † #{verse_text}",
              :ts => Time.now().to_i
            }
          ]
        })
      end

    end
  end
end