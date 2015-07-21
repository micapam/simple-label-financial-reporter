require_relative './model'

class Release < Struct.new(:catalogue_number, :title, :release_date,
    :mastering_cost, :distribution_cost, :promotion_cost, :artist_split,
    :recoup_costs_before_split)
    
  include Model

  attr_accessor :catalogue_number, :title, :release_date, :mastering_cost,
    :distribution_cost, :promotion_cost, :artist_split,
    :recoup_costs_before_split, :sales_periods

  has_many :revenue_tallies
  has_many :payouts
  belongs_to :artist
  
  def amount_paid_out 
    payouts.collect {|payout| payout.amount }.inject(:+)
  end
  
  def balance(include_latest_tally: true)
    total_revenue(include_latest: include_latest_tally) + initial_costs
  end
  
  def first_report?
    revenue_tallies.count < 2
  end
  
  def initial_costs
    mastering_cost + distribution_cost + promotion_cost
  end
  
  def latest_tally
    revenue_tallies.sort do |tally|
      tally.sales_period.ends_at
    end
  end
  
  def only_first(att)
    raise "Unknown attribute: #{att}" unless respond_to? att

    if first_report?
      self.send att
    else
      'N/A'
    end
  end
  
  def owed_to_artist
    owed_ever = balance * artist_split    
    [0, owed_ever - amount_paid_out].max
  end
  
  def promotion_and_ongoing_cost
    promotion_cost + (latest_tally.try(:ongoing_costs) || 0)
  end      
  
  def total_revenue(include_latest: true)
    revenue_tallies.collect {|tally|
      tally.net_revenue
    }.select {|tally|
      include_latest || tally != latest_tally
    }.inject(:+)
  end

end