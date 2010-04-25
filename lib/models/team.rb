class Team < Ohm::Model
  attribute :name
  attribute :rs_id
  collection :games, Game
  collection :lineups, Lineup
  reference :league, League
  
  index :name
  index :rs_id
end