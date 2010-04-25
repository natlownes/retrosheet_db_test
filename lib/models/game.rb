class Game < Ohm::Model
  attribute :attendence
  attribute :rs_id
  
  attribute :year
  attribute :month
  attribute :day
  
  
  reference :home_team, Team
  reference :away_team, Team
  
  reference :home_lineup, Lineup
  reference :away_lineup, Lineup
  
  index     :rs_id
  
  index :year
  index :month
  index :day
  
end