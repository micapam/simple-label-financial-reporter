require_relative './model'

class Release < Struct.new(:title, :release_date, :mastering_cost,
	:distribution_cost, :promotion_cost, :artist_split, :recoup_costs_before_split)
  include Model

  attr_accessor :title, :release_date, :mastering_cost, 
    :distribution_cost, :promotion_cost, :artist_split,
    :recoup_costs_before_split, :sales_periods

  has_many :sales_periods
  belongs_to :arist

end