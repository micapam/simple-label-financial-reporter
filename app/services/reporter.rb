class Reporter
  class << self

  	attr_reader :reports

    def generate
      DataStore.load
    end

    def initialise
      @reports = []
    end

  end
end