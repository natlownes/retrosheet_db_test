class LineupEntry < Ohm::Model
  attribute :batting_position
  index     :batting_position
  
  reference :lineup, Lineup
  reference :player, Player
  reference :position, Position

  def position_for_graph
    position_map = {
      1 => 9,
      2 => 8,
      3 => 7,
      4 => 6,
      5 => 5,
      6 => 4,
      7 => 3,
      8 => 2,
      9 => 1
    }
    position_map[self.batting_position.to_i]
  end
end
