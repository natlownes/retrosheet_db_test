require File.dirname(__FILE__) + "/../init"
require 'fastercsv'
require 'set'

Ohm.flush()

filepath = File.expand_path(ARGV[0])
data = FasterCSV.parse(File.read(filepath))

["NL", "AL"].each do |l|
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
  Position.create(:number => number, :name => name)
end

teams = Set.new
data.map do |game_data_row|
  home = game_data_row[3..4]
  away = game_data_row[6..7]
  teams << home
  teams << away
end

teams.each do |team, league|
  t = Team.new(:name => team)
  t.league = League.find(:name => league).first
  t.save
end

def home_lineup_data(array)
  # playerid name position_number
  array[132..158].each_slice(3).to_a
end

def away_lineup_data(array)
  array[105..131].each_slice(3).to_a
end

data.each do |game_data_row|
  date = game_data_row[0]
  game = Game.new(:date => date)
  game.home_team = Team.find(:name => game_data_row[3]).first
  game.away_team = Team.find(:name => game_data_row[6]).first
  
  puts game.home_team.inspect
  puts game.away_team.inspect
  
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