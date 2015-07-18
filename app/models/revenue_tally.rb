class RevenueTally < Struct.new(:gross_revenue, :ongoing_costs, :comment)
  include Model

  attr_accessor :gross_revenue, :ongoing_costs, :comment

  belongs_to :release
  belongs_to :sales_period
  
  def net_revenue
    gross_revenue - ongoing_costs
  end
end