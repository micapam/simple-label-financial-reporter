RELEASE_ATTRIBUTES = [:catalogue_number, :title, :release_date,
  :mastering_cost, :distribution_cost, :promotion_cost, :artwork_cost,
  :artist_split, :recoup_costs_before_split, :artist]

class Release < Struct.new *RELEASE_ATTRIBUTES
  
  def amount_paid_out 
    payouts.collect {|payout| payout.amount }.inject(:+) || 0
  end
  
  def balance_carried_forward
    balance include_latest_tally: false
  end
  
  def balance(include_latest_tally: true)
    total_revenue(include_latest: include_latest_tally) - initial_costs
  end
  
  def first_report?
    revenue_tallies.count < 2
  end
  
  def initialize(h)
    super *h.values_at(*RELEASE_ATTRIBUTES)
  end
  
  def initial_costs
    mastering_cost + artwork_cost + distribution_cost + promotion_cost
  end
  
  def latest_tally
    revenue_tallies.sort { |tally|
      tally.sales_period.ends_at
    }.last
  end
  
  def only_first(att)
    raise "Unknown attribute: #{att}" unless respond_to? att

    if first_report?
      self.send att
    else
      'N/A'
    end
  end
  
  def only_non_first(att)
    raise "Unknown attribute: #{att}" unless respond_to? att

    if first_report?
      'N/A'
    else
      self.send att
    end
  end
  
  def owed_to_artist
    owed_ever = balance * artist_split    
    [0, owed_ever - amount_paid_out].max
  end
  
  def payouts
    @payouts ||= []
  end
  
  def promotion_and_ongoing_cost
    promotion_cost + (latest_tally.try(:ongoing_costs) || 0)
  end     
  
  def revenue_tallies
    @revenue_tallies ||= []
  end
  
  def sales_periods
    @sales_periods ||= []
  end 
  
  def total_revenue(include_latest: true)
    revenue_tallies.collect {|tally|
      tally.net_revenue
    }.select {|tally|
      include_latest || tally != latest_tally
    }.inject(:+) || 0
  end

end