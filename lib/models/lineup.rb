class Lineup < Ohm::Model
  attribute :date
  reference :game, Game
  reference :team, Team
  list :entries, LineupEntry
  
  def to_s
    a = []
    self.entries.each_with_index do |lineup_entry, index|
      index = index + 1
      a << ["#{'%02d' % (index).to_s}.", lineup_entry.position.name, lineup_entry.player.name].join("  ")
    end
    a.join("\n")
  end
  
end