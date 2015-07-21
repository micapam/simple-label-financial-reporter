require 'active_support/inflector'

class DataStore 
  class << self

    attr_reader :artists, :releases, :sales_periods, :revenue_tallies, :payouts

    def configure 
      yield config
    end
    
    def find_artist(real_name)
      artists.select do |artist|
        artist.real_name == real_name
      end
    end
    
    def find_release(catalogue_number)
      release.select do |release|
        release.catalogue_number == catalogue_number
      end
    end

    def initialize
      reset
    end

    def load
      reset

      CSV.foreach artists_path do |row|
        artists << create_artist row
      end
      
      CSV.foreach releases_path do |row|
        releases << create_release row
      end
      
      sales_period_paths.each do |path|
        date_str = path.scan(/\d{8}/).first
        sales_period = SalesPeriod.new ends_at: Date.parse date_str
        
        CSV.foreach path do |row|
          revenue_tallies << create_revenue_tally row, sales_period
        end
        
        sales_periods << sales_period
      end
      
      # TODO payouts
    end
    
    def tallies 

    def reset
      %w(artists releases sales_periods revenue_tallies payouts).each do |arr|
        send '@#{arr}=', []
      end
    end

    # Overwrite data files with artists and releases in memory
    def save!(destroy_records: false)
      unless destroy_records
        if File.exists? artists_path || File.exists? releases_path 
          raise 'Destructive method! Files already exist. If you are OK to'
            ' destroy them, call #save! again with with destroy_records: true'
        end
      end
      
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
      
      sales_periods.each do |period|
        CSV.open sales_period_path(period), 'wb' do |csv|
          sales_period.revenue_tallies.each do |tally|
            csv << create_row(tally)
          end
        end
      end
      
      #TODO payouts
    end

    private 

    def artists_path
      data_path Artist
    end

    def config
      @config ||= DataStore::Configuration.new
    end

    def create_artist(row)
      Artist.new hash_from_row :primary_alias,
        :real_name       
    end
    
    def create_release(row)
      release = Release.new hash_from_row :catalogue_number,
        nil, # Artist name
        :title,
        :release_date,
        :mastering_cost,
        :distribution_cost,
        :promotion_cost,
        :artist_split,
        :recoup_costs_before_split
      
      release.artist = find_artist row[1] # Artist name
      release
    end
    
    def create_revenue_tally(row, sales_period) 
      tally = RevenueTally.new hash_from_row nil, # Release catalogue number
        :gross_revenue,
        :ongoing_costs,
        :comment
        
      tally.release = find_release row[0] # Release catalogue number
      tally
    end

    def create_row(thing)
      case thing
      when Artist
        [ thing.primary_alias,
          thing.real_name ]
      when Release
        [ thing.catalogue_number,
          thing.artist.real_name,
          thing.title,
          thing.release_date,          
          thing.mastering_cost,
          thing.distribution_cost,
          thing.promotion_cost,
          thing.artist_split,
          thing.recoup_costs_before_split ]
      
      else
        raise "Unknown entity: #{thing}"
      end
    end

    def data_path(clazz)
      "#{config.data_location}/#{clazz.name.pluralize.underscore}.csv" 
    end
    
    def sales_period_path(sales_period)
      date_str = sales_period.ends_at.strftime('%Y%m%d')
      "#{config.data_location}/sales_#{date_str}.csv"
    end
    
    def sales_period_paths
      Dir["#{config.data_location}/sales_*.csv"].select do |path|
        path =~ /sales_\d{8}\.csv$/
      end
    end

    def hash_from_row(row, *keys)
      hash = {}

      keys.each_with_index do |key, i|
        hash[key] = row[i] if key.present?        
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