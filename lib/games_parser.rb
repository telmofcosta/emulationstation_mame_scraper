class GamesParser
  attr_reader :full_parsed_games_data, :snap_dir
  attr_reader :roms_dir
  attr_reader :snaps_dir

  def initialize(full_parsed_games_data, roms_dir, snaps_dir)
    @full_parsed_games_data = full_parsed_games_data
    @roms_dir = roms_dir
    @snaps_dir = snaps_dir
  end

  def parse
    $stderr.puts "snaps in #{snaps_dir}"
    $stderr.puts "parsing games in: #{roms_dir}"
    Dir.glob(zip_files_pattern).sort.reduce({}) do |hash, game_zip_file|
      rom_name = File.basename(game_zip_file, ".zip")
      parsed_game_data = full_parsed_games_data[rom_name] || {}

      unless ignore_game?(parsed_game_data)
        hash[rom_name] = {
          :game_zip_file => game_zip_file,
          :name => rom_name,
          :description => parsed_game_data["description"],
          :publisher => parsed_game_data["manufacturer"],
          :releasedate => parsed_game_data["year"],
          :image => image_file(rom_name)
        }
      end
      hash
    end
  end

  def ignore_game?(game_data)
    %w(ismechanical isdevice isbios).map{ |type| game_data[type] }.any?
  end

  def image_file(rom_name)
    file = File.join(snaps_dir, "#{rom_name}.png")
    File.file?(file) ? file : nil
  end

  def zip_files_pattern
    @zip_files_pattern ||= File.join(roms_dir, "*.zip")
  end

end
