#!/usr/bin/env ruby

require 'json'
require_relative 'lib/data_parser'
require_relative 'lib/games_parser'
require_relative 'lib/gamelist_generator'

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

gamelist_generator = GamelistGenerator.new(games_data)
gamelist_generator.generate
