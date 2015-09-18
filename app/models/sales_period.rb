SALES_PERIOD_ATTRIBUTES = [:begins_at, :ends_at]

class SalesPeriod < Struct.new(*SALES_PERIOD_ATTRIBUTES)  
  attr_accessor :revenue_tallies
  
  def initialize(h)
    super *h.values_at(*SALES_PERIOD_ATTRIBUTES)
    @revenue_tallies = []
  end
  
  def to_s 
    if begins_at.present?
      "during #{pretty_date(begins_at)} to #{pretty_date(ends_at)}"
    else
      "until #{pretty_date(ends_at)}"
    end
  end
  
  def pretty_date(date)
    date.strftime '%d/%m/%Y'
  end
end