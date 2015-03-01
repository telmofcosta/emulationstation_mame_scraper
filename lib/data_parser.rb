class DataParser
  attr_reader :games_data_file_name

  def initialize(games_data_file_name)
    @games_data_file_name = games_data_file_name
  end

  def needs_uncompressing?
    !File.file?(games_data_file_name) || File.file?("#{games_data_file_name}.gz")
  end

  def uncompress
    $stderr.puts "uncompressing: #{games_data_file_name}.gz"
    `gzip -dc #{games_data_file_name}.gz > #{games_data_file_name}`
  end

  def parse
    $stderr.puts "parsing file: #{games_data_file_name}"
    full_parsed_games_data = JSON.parse(File.read(games_data_file_name))
  end
end
