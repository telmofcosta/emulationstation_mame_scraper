This is a ruby emulationstation scraper for mame games.

you need the xml-simple gem
```
gem install xml-simple
```

Scraper uses games_data.json file to generate a new emulationstation mame gamelists file.
the current games_data.json is based on mame0.155

You can generate a games_data.json from another mame version



1. generate games_data.json (you may skip this step)

  ```
  mame -listxml > listxml.xml`
  ./generate_games_data.rb listxml.xml
  ```
  this will generate a new games_data.json

2. generate emulationstation gamelist.xml

  ```
  ./scraper.rb roms_dir [snapshots_dir] [games_data_file] > gamelist.xml
  ```
  *roms_dir* is where you have your mame roms  
  *snapshots_dir* is where you have your mame snapshots  
  *games_data_file* is the generated json data file  

  if you don't have snapshots, just ignore it

3. copy gamelist.xml to the correct emulationstation folder.
  On my linux it's:
  `~/.emulationstation/gamelists/mame/`
