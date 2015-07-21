class SalesPeriod < Struct.new(:begins_at, :ends_at)  
  include Model
  
  attr_accessor :ends_at
  
  has_many :revenue_tallies

end