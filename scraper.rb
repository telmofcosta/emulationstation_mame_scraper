#!/usr/bin/env ruby

require 'json'
require_relative 'lib/data_parser'

roms_dir = ARGV[0]
snaps_dir = ARGV[1] || ARGV[0]
games_data_file = ARGV[2] || 'games_data.json'

unless roms_dir
  $stderr.puts "first param must be roms dir"
  exit 1
end

data_parser = DataParser.new(games_data_file)
data_parser.uncompress if data_parser.needs_uncompressing?
full_parsed_games_data = data_parser.parse

$stderr.puts "parsing games in: #{roms_dir}"
zip_files_pattern = File.join(roms_dir, "*.zip")
games_data = Dir.glob(zip_files_pattern).sort.reduce({}) do |hash, game_zip_file|
  # $stderr.puts game_zip_file
  rom_name = File.basename(game_zip_file, ".zip")
  parsed_game_data = full_parsed_games_data[rom_name] || {}
  image_file = File.join(snaps_dir, "#{rom_name}.png")
  image_file = nil unless File.file?(image_file)

  unless %w(ismechanical isdevice isbios).map{ |type| parsed_game_data[type] }.any?
    hash[rom_name] = {
      :game_zip_file => game_zip_file,
      :name => rom_name,
      :description => parsed_game_data["description"],
      :publisher => parsed_game_data["manufacturer"],
      :releasedate => parsed_game_data["year"],
      :image => image_file
    }
  end
  hash
end

puts '<?xml version="1.0"?>'
puts "<gameList>"
games_data.values.each do |game_data|
  puts "  <game>"
  puts "    <path>#{game_data[:game_zip_file]}</path>"
  puts "    <name>#{game_data[:description]}</name>" if game_data[:description]
  puts "    <publisher>#{game_data[:publisher]}</publisher>" if game_data[:publisher]
  puts "    <releasedate>#{game_data[:releasedate]}</releasedate>" if game_data[:releasedate]
  puts "    <image>#{game_data[:image]}</image>" if game_data[:image]
  puts "    <rating>0.000000</rating>"
  puts "    <userrating>0.000000</userrating>"
  puts "    <timesplayed>0</timesplayed>"
  puts "  </game>"
end
puts "</gameList>"
