class LineupEntry < Ohm::Model
  attribute :batting_position
  index     :batting_position
  
  reference :lineup, Lineup
  reference :player, Player
  reference :position, Position
end