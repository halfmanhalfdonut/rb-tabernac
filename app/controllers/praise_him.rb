require 'singleton'

class PraiseHimController
  include Singleton

  def get_book( text )
    text.match(/\d?\s?[a-zA-Z]+/)
  end

  def get_chapter_and_verses( text )
    chapter = ""
    verses = ""

    text.split(' ').each do |value|
      splits = value.split(':')

      if splits.length > 1
        chapter = splits[0]
        verses = splits[1]
      end
    end

    [ chapter, verses ]
  end

  def get_start_and_end_verse( text )
    text.split('-')
  end

  def get_text( bibles, book_id, chapter, start_verse, end_verse )
    text = {}

    if book_id && chapter && start_verse
      verse = Verse.new
      bibles.each do |bible|
        verses = verse.get_verses( bible[:table], book_id, chapter, start_verse, end_verse )
        verses.push({
          :url => bible[:url],
          :text => bible[:version],
        })

        text[bible[:version]] = verses
      end
    end

    text
  end

  def get_attachments( verse_text )
    attachments = []
    ts = Time.now().to_i # timestamp since epoch

    verse_text.each do |key, value|
      attachment = {}
      attachment[:title] = key
      txt = ""
      value.each do |line|
        if line[:verse]
          txt += "#{line[:verse]} #{line[:text]}\n"
        else
          attachment[:title] = line[:text]
          attachment[:title_link] = line[:url]
        end
      end
      attachment[:text] = txt
      attachment[:ts] = ts

      attachments.push attachment
    end

    attachments
  end

  def handle
    get_verse = lambda do
      request.body.rewind
      data = JSON.parse request.body.read

      # No params sent, just let it fall through to the 404 handler which randomizes
      pass unless data.token == ENV['TABERNAC_TOKEN'] && data.text != ""

      book = get_book( data.text )
      chapter, verses = get_chapter_and_verses( data.text )
      start_verse, end_verse = get_start_and_end_verse( verses )

      bible_db = Bible.new
      bibles = bible_db.get_all_bibles

      book_db = Book.new
      book_id = book_db.get_book_by_name( book )

      verse_text = get_text( bibles, book_id, chapter, start_verse, end_verse )

      JSON.generate({
        :response_type => "in_channel",
        :text => "Praise Him! †",
        :attachments => get_attachments( verse_text )
      })
    end
  end
end