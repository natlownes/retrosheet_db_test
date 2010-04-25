class Person < Ohm::Model
  attribute :name
  attribute :rs_id
  index :rs_id
end