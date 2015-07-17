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
  belongs_to :arist
  
  def amount_paid_out 
    payouts.collect {|payout| payout.amount }.inject(:+)
  end
  
  def balance
    revenue_tallies.collect {|tally| tally.net_revenue }.inject(:+)
  end
  
  def initial_costs
    mastering_cost + distribution_cost + promotion_cost
  end
  
  def latest_tally
    revenue_tallies.sort do |tally|
      tally.sales_period.ends_at
    end
  end
  
  def owed_to_artist
    owed_ever = balance * artist_split    
    [0, owed_ever - amount_paid_out].max
  end

end