#!/usr/bin/env ruby

require 'xmlsimple'
require 'json'

listxml_file = 'listxml.dat'
exclusion_patterns_file = 'listxml-exclude.txt'
listxml_filtered_file = 'listxml.filtered.xml'
json_data_file = 'games_data.json'

$stdout.puts "Step 1/3 first pass filter #{listxml_file} to #{listxml_filtered_file}"
`grep -vf #{exclusion_patterns_file} #{listxml_file} > #{listxml_filtered_file}`

$stdout.puts "Step 2/3 parsing #{listxml_filtered_file}"
parsed_games_data = XmlSimple.xml_in(listxml_filtered_file)['game']
hashed_parsed_games_data = parsed_games_data.reduce({}) do |hash, game|
  game_data = game.reduce({}) do |game_hash, (attr, value)|
    game_hash[attr] = value.is_a?(Array) ? value.first : value
    game_hash
  end
  if game_data["input"]
    game_data["input"] = game_data["input"].select { |k, v| %w(players buttons).include?(k)} 
  end
  hash[game["name"]] = game_data
  hash
end; 0

$stdout.puts "Step 3/3 generating games data file #{json_data_file}"
File.open(json_data_file, 'w') do |json_file|
  json_file.write(JSON.pretty_generate(hashed_parsed_games_data))
end
