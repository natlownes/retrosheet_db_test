class Game < Ohm::Model
  attribute :attendence
  attribute :date
  attribute :rs_id
  
  reference :home_team, Team
  reference :away_team, Team
  
  reference :home_lineup, Lineup
  reference :away_lineup, Lineup
  
  index     :rs_id
  index     :date
end