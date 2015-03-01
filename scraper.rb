#!/usr/bin/env ruby

require 'json'
require_relative 'lib/data_parser'
require_relative 'lib/games_parser'

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

games_parser = GamesParser.new(full_parsed_games_data, roms_dir, snaps_dir)
games_data = games_parser.parse

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
