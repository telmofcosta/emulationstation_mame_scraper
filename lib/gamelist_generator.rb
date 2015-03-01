class GamelistGenerator
  attr_accessor :games_data

  def initialize(games_data)
    @games_data = games_data
  end

  def generate
    puts '<?xml version="1.0"?>'
    puts "<gameList>"
    games_data.values.each do |game_data|
      puts "  <game>"
      puts "    <path>#{game_data[:game_zip_file]}</path>"
      puts "    <name><![CDATA[#{game_data[:description]}]]></name>" if game_data[:description]
      puts "    <publisher><![CDATA[#{game_data[:publisher]}]]></publisher>" if game_data[:publisher]
      puts "    <releasedate>#{game_data[:releasedate]}</releasedate>" if game_data[:releasedate]
      puts "    <image>#{game_data[:image]}</image>" if game_data[:image]
      puts "    <rating>0.000000</rating>"
      puts "    <userrating>0.000000</userrating>"
      puts "    <timesplayed>0</timesplayed>"
      puts "  </game>"
    end
    puts "</gameList>"
  end
end
