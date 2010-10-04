class Player < Person
  attribute :name
  attribute :rs_id
  
  collection :lineup_entries, LineupEntry
  
  index :rs_id
  index :name

  def self.in_lineups(lineups)
    set = []
    lineups.each do |lineup|
      lineup.players.each do |p|
        if !set.map(&:id).include?(p.id) 
          set << p
        end
      end
    end
    set
  end

  def to_hex_color
    digest = Digest::MD5.hexdigest(self.rs_id)
    digest[0..5]
  end
  
end
