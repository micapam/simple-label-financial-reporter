ARTIST_ATTRIBUTES = [:real_name, :primary_alias]

class Artist < Struct.new *ARTIST_ATTRIBUTES
  attr_accessor :releases

  def amount_owed
    releases.collect {|release| release.owed_to_artist }.inject(:+) || 0
  end
  
  def initialize(h)
    super *h.values_at(*ARTIST_ATTRIBUTES)
    @releases = []
  end
  
  def releases_with_sales
    releases.select do |release| 
      release.revenue_tallies.any?
    end
  end

end