require 'game'
require 'team'
require 'lineup_entry'
require 'player'

class Lineup < Ohm::Model
  attribute :year
  attribute :month
  attribute :day
  reference :game, :Game
  reference :team, :Team
  list :entries, :LineupEntry
  
  index     :year
  index     :month
  index     :day

  def self.history_for_graph(lineups)
    lineups = lineups.sort {|a,b| a.date <=> b.date }
    datastore = {
      :graph_lines => [],
      :lineups => {}
    }
    roster = Player.in_lineups(lineups)
    player_store = roster.inject({}) {|store, player| store[player.rs_id] = [] ; store }

    lineups.each do |lineup|
      game_n = lineup.game_number
      datastore[:lineups][game_n] = {
        :game => game_n,
        :date => lineup.date,
        :text => lineup.to_s
      }
      roster.each do |player|
        if lineup.has_player?(player)
          entry = lineup.entries.detect {|e| e.player_id == player.id }
          start = {
            :name => entry.player.name, 
            :y => entry.position_for_graph,
            :x => game_n,
            :rs_id => entry.player.rs_id,
            :field_position => entry.position.name,
            :color => entry.player.to_hex_color
          }
          stop = {
            :name => entry.player.name, 
            :y => entry.position_for_graph,
            :x => game_n +1,
            :rs_id => entry.player.rs_id,
            :field_position => entry.position.name,
            :color => entry.player.to_hex_color
          }
          player_store[player.rs_id] << start
          player_store[player.rs_id] << stop
        else
          player_store[player.rs_id] << nil
        end #if
      end #roster
    end #lineups

    player_store.each do |retrosheet_id, entries|
      entries.split(nil).each do |array|
        # these will be 'lines' on the vis
        datastore[:graph_lines] << array
      end
    end

    datastore
  end

  def has_player?(player)
    self.players.include?(player)
  end

  def date
    Date.parse("#{self.year}-#{self.month}-#{self.day}")
  end
  
  def to_s
    a = []
    self.entries.each_with_index do |lineup_entry, index|
      index = index + 1
      a << ["#{'%02d' % (index).to_s}.", lineup_entry.position.name, lineup_entry.player.name].join("  ")
    end
    a.join("\n")
  end
  
  def to_a
    self.entries.map do |lineup_entry|
      [lineup_entry.player.name, lineup_entry.position.name]
    end
  end

  def game_number
    # return the nth game this is for the team
    self.team.lineups.sort{|a,b| a.date <=> b.date }.to_a.index(self)
  end

  def players
    @players ||= self.entries.map(&:player)
  end
end
