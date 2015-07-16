require_relative './model'

class Release < Struct.new(:catalogue_number, :title, :release_date,
    :mastering_cost, :distribution_cost, :promotion_cost, :artist_split,
    :recoup_costs_before_split)
    
  include Model

  attr_accessor :catalogue_number, :title, :release_date, :mastering_cost,
    :distribution_cost, :promotion_cost, :artist_split,
    :recoup_costs_before_split, :sales_periods

  has_many :sales_periods
  belongs_to :arist

end