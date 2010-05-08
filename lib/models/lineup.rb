class Lineup < Ohm::Model
  attribute :year
  attribute :month
  attribute :day
  reference :game, Game
  reference :team, Team
  list :entries, LineupEntry
  
  index     :year
  index     :month
  index     :day
  
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
  
  def date
    Date.parse("#{year}-#{month}-#{day}")
  end
  
end