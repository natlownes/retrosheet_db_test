class LineupEntry < Ohm::Model
  reference :lineup, Lineup
  reference :player, Player
  reference :position, Position
end