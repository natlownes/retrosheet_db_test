class League < Ohm::Model
  attribute :name
  index     :name
  collection  :teams, Team
end