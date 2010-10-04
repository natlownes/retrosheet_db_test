class Team < Ohm::Model
  attribute :name
  attribute :rs_id
  collection :games, Game
  collection :lineups, Lineup
  reference :league, League
  
  index :name
  index :rs_id

  def players
    set = []
    self.lineups.each do |lineup|
      lineup.players.each do |p|
        if !set.map(&:id).include?(p.id) 
          set << p
        end
      end
    end
    set
  end
end
