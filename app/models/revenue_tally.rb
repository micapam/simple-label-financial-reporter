class RevenueTally < Struct.new(:sales_revenue, :licensing_revenue, :ongoing_costs, :comment)
  include Model

  attr_accessor :sales_revenue, :licensing_revenue, :ongoing_costs, :comment

  belongs_to :release
  belongs_to :sales_period
  
  def gross_revenue
    sales_revenue + licensing_revenue
  end
  
  def net_revenue
    gross_revenue - ongoing_costs
  end
end