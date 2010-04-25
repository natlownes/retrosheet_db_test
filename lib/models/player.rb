class Player < Person
  attribute :name
  attribute :rs_id
  
  collection :lineup_entries, LineupEntry
  
  index :rs_id
  
  def to_hex_color
    digest = Digest::MD5.hexdigest(self.name)
    digest = digest[0..5]
    # digest.unpack('U' * digest.length).collect {|x| x.to_s 16}
  end
  
end