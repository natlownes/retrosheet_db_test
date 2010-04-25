class Player < Person
  attribute :name
  attribute :rs_id
  
  collection :lineup_entries, LineupEntry
  
  index :rs_id
  
  def to_hex_color
    digest = Digest::MD5.hexdigest(self.rs_id)
    digest[0..5]
  end
  
end