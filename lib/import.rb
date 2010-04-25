require File.dirname(__FILE__) + "/../init"
require 'optparse'
require 'fastercsv'
require 'set'

options = {}

OptionParser.new do |opts|
  opts.banner = %{
    Usage:  import.rb [options] [file]
  }
  
  opts.on("-d", "--drop", "Drop DB before import.") do |v|
    options[:drop_db] = v
  end
  
  opts.on("-b", "--bootstrap", "Create Leagues and Positions.") do |v|
    options[:bootstrap] = v
  end
  
  opts.on("-t", "--teams", "Create Teams (if they don't exist) from dataset.") do |v|
    options[:teams] = v
  end
  
  opts.on("-i", "--import", "Import data from paths.") do |v|
    options[:import] = v
  end
  
end.parse!

if options[:drop_db]
  # set bootstrap and team if db is dropped...
  options[:bootstrap] = true
  options[:teams] = true
  puts "dropping db..."
  Ohm.flush()
end

filepaths = ARGV
csv_text = ""

filepaths.each do |path|
  path = File.expand_path(path)
  csv_text << File.read(path)
end

data = FasterCSV.parse(csv_text)

if options[:bootstrap]
  ["NL", "AL"].each do |l|
    next if League.find(:name => l).first
    League.create(:name => l)
  end

  positions = {
    1 => "P",
    2 => "C",
    3 => "1B",
    4 => "2B",
    5 => "3B",
    6 => "SS",
    7 => "LF",
    8 => "CF",
    9 => "RF",
    10 => "DH"
  }

  positions.each do |number, name|
    next if Position.find(:number => number).first
    Position.create(:number => number, :name => name)
  end
end

if options[:teams]
  teams = Set.new
  data.map do |game_data_row|
    home = game_data_row[3..4]
    away = game_data_row[6..7]
    teams << home
    teams << away
  end

  teams.each do |team, league|
    next if Team.find(:name => team).first
    t = Team.new(:name => team)
    t.league = League.find(:name => league).first
    t.save
  end
end

def home_lineup_data(array)
  # playerid name position_number
  array[132..158].each_slice(3).to_a
end

def away_lineup_data(array)
  array[105..131].each_slice(3).to_a
end

if options[:import]
  data.each do |game_data_row|
    date = game_data_row[0]
    game = Game.new(:date => date)
    game.home_team = Team.find(:name => game_data_row[3]).first
    game.away_team = Team.find(:name => game_data_row[6]).first
    
    puts "Importing #{date} - #{game.away_team.name} @ #{game.home_team.name}"
    
    game.save
  
    home_lineup = Lineup.create(:team => game.home_team, :date => date, :game => game)
    away_lineup = Lineup.create(:team => game.away_team, :date => date, :game => game)
  
    game.home_lineup = home_lineup
    game.away_lineup  = away_lineup
  
    game.save
  
    home_lineup_data(game_data_row).each do |player_id, name, position_number|
      player = Player.find(:rs_id => player_id).first || Player.create(:rs_id => player_id, :name => name)
      entry = LineupEntry.new(:lineup => home_lineup)
      entry.player = player
      entry.position = Position.find(:number => position_number).first
      entry.save
      home_lineup.game = game
      home_lineup.team = game.home_team
      home_lineup.entries << entry
      home_lineup.save
    end
  
    away_lineup_data(game_data_row).each do |player_id, name, position_number|
      player = Player.find(:rs_id => player_id).first || Player.create(:rs_id => player_id, :name => name)
      entry = LineupEntry.new(:lineup => away_lineup)
      entry.lineup = away_lineup
      entry.player = player
      entry.position = Position.find(:number => position_number).first
      entry.save
      away_lineup.game = game
      home_lineup.team = game.away_team
      away_lineup.entries << entry
      away_lineup.save
    end
  
  end
end