class Reporter
  class << self

  	attr_reader :reports

    def generate
      DataStore.load
      
      DataStore.artists.each do |artist|
        @reports << Report.new artist        
      end
    end

    def initialise
      @reports = []
    end

  end
end