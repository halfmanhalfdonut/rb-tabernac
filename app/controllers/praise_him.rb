require 'singleton'
require 'uri'
require 'json'

module Tabernac
  module Controllers
    class PraiseHim
      include Singleton

      def get_book( text )
        text.match(/\d?\s?[a-zA-Z]+/).to_s
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
          verse = Tabernac::Models::Verse.new
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
        lambda do
          request.body.rewind
          data = JSON.parse( Hash[URI.decode_www_form( request.body.read )].to_json )

          controller = PraiseHim.instance

          # No params sent, just let it fall through to the 404 handler which randomizes
          pass unless data["token"] == ENV["TABERNAC_TOKEN"] && data["text"] != ""

          book = controller.get_book( data["text"] )
          chapter, verses = controller.get_chapter_and_verses( data["text"] )
          start_verse, end_verse = controller.get_start_and_end_verse( verses )

          bible_db = Tabernac::Models::Bible.new
          bibles = bible_db.get_all_bibles

          book_db = Tabernac::Models::Book.new
          book_id = book_db.get_book_by_name( book )

          verse_text = controller.get_text( bibles, book_id, chapter, start_verse, end_verse )

          content_type :json
          JSON.generate({
            :response_type => "in_channel",
            :text => "Praise Him! †",
            :attachments => PraiseHim.instance.get_attachments( verse_text )
          })
        end
      end
    end
  end
end