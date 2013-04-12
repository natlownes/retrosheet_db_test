require 'lineup_entry'

class Position < Ohm::Model
  attribute :number
  attribute :name
  
  index     :number
  index     :name
  
  reference :lineup_entry, :LineupEntry
end
