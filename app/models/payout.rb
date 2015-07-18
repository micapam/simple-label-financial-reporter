class Payout < Struct.new(:amount)
  include Model
  
  attr_accessor :amount
  
  belongs_to :release
  
end
  