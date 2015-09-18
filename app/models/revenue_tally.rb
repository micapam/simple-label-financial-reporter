REVENUE_TALLY_ATTRIBUTES = [:sales_revenue, :licensing_revenue, :ongoing_costs,
  :comment, :release, :sales_period]

class RevenueTally < Struct.new(*REVENUE_TALLY_ATTRIBUTES)
  
  def gross_revenue
    sales_revenue + licensing_revenue || 0
  end
  
  def initialize(h)
    super *h.values_at(*REVENUE_TALLY_ATTRIBUTES)
  end
  
  def net_revenue
    gross_revenue - ongoing_costs || 0
  end
end