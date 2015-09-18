require 'haml'
require 'tilt'

class Report < Struct.new(:artist, :current_sales_period)
  
  attr_reader :content
  
  def render 
    view = Tilt.new('app/views/report.haml')
    
    @content = view.render self, artist: artist,
      current_sales_period: current_sales_period
  end

end