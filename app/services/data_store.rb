require 'active_support/inflector'

class DataStore 
  class << self

  	attr_accessor :artists

  	def configure 
      yield config
  	end

  	def initialize
  	  reset
  	end

  	def load
  	  reset

  	  CSV.foreach artists_path do |row|
  	  	artists << create_artist(row)
  	  end
  	end

  	def releases
  	  artists.collect {|artist|
  	  	artist.releases
  	  }.flatten
  	end

    def reset
      @artists = []
    end

    # Overwrite data files with artists and releases in memory
    def save!
      CSV.open artists_path, 'wb' do |csv|
      	artists.each do |artist|
      	  csv << create_row(artist)
      	end
      end

      CSV.open releases_path, 'wb' do |csv|
      	releases.each do |release|
      	  csv << create_row(release)
      	end
      end
    end

    private 

    def artists_path
      data_path Artist
    end

    def config
      @config ||= DataStore::Configuration.new
    end

    def create_artist(row)
      Artist.new hash_from_row :primary_alias, :real_name
    end

    def create_row(thing)
      case thing
      when Artist
      	[ thing.primary_alias,
      	  thing.real_name ]
      when Release
      	[  ]
      else
      	raise "Unknown entity: #{thing}"
      end
    end

    def data_path(clazz)
      "#{config.data_location}/#{clazz.name.pluralize}.csv" 
    end

    def hash_from_row(row, *keys)
      hash = {}

      keys.each_with_index do |key, i|
      	hash[key] = row[i]
      end

      hash
    end

    def releases_path
      data_path Release
    end

  end
end

module DataStore
  class Configuration 

    attr_accessor :data_location

    def initialize
      @data_location = './data'
    end

  end
end