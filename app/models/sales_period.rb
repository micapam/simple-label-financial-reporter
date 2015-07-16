class SalesPeriod < Struct.new(:begins_at, :ends_at)  
  include Model
  
  attr_accessor :begins_at, :ends_at
  
  has_many :release_

end