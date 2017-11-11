class Bible
  include DbConnected

  def get_all_bibles
    bibles = []

    @db.execute "select \"id\", \"table\", \"version\", \"info_url\" from bible_versions" do |row|
      bibles.push({
        :table => row[1],
        :version => row[2],
        :url => row[3]
      })
    end

    bibles
  end

  def get_random_bible
    bibles = get_all_bibles()
    bibles[1 + rand( bibles.length )]
  end

  def get_bible( bible_id )
    bible = {}

    @db.execute( "select \"table\", \"version\", \"info_url\" from bible_versions where id = :bible_id", :bible_id => bible_id ) do |row|
      bible = {
        :table => row[0],
        :version => row[1],
        :url => row[2]
      }
    end

    bible
  end
end