require 'active_support/inflector'
require 'csv'

class DataStore 
  class << self

    attr_reader :artists, :releases, :sales_periods, :revenue_tallies, :payouts

    def configure 
      yield config
    end
    
    def find_artist(primary_alias)
      artists.find do |artist|
        artist.primary_alias == primary_alias
      end
    end
    
    def find_release(catalogue_number)
      releases.find do |release|
        release.catalogue_number == catalogue_number
      end
    end
    
    def latest_sales_period      
      sales_periods.sort { |period|
        period.ends_at
      }.reverse.last
    end

    def load
      reset

      CSV.foreach artists_path, headers: :first_row do |row|
        artists << create_artist(row)
      end
      
      CSV.foreach releases_path, headers: :first_row do |row|
        releases << create_release(row)
      end
      
      last_sales_period = nil
      
      sales_period_paths.each do |path|
        date_str = path.scan(/\d{8}/).first
        date = Date.parse(date_str)
        
        next if date > LabelReporter.config.until_date
        
        sales_period = SalesPeriod.new(ends_at: date,
          begins_at: last_sales_period.try(:ends_at))
        
        CSV.foreach path, headers: :first_row do |row|
          revenue_tallies << create_revenue_tally(row, sales_period)
        end
        
        sales_periods << sales_period
        last_sales_period = sales_period
      end
      
      # TODO payouts
    end
    
    def tallies 
    end

    def reset
      %w(artists releases sales_periods revenue_tallies payouts).each do |arr|
        instance_variable_set "@#{arr}", []
      end
    end

    # Overwrite data files with artists and releases in memory
    def save!(destroy_records: false)
      unless destroy_records
        if File.exists?(artists_path) || File.exists?(releases_path)
          raise 'Destructive method! Files already exist. If you are OK to'
            ' destroy them, call #save! again with with destroy_records: true'
        end
      end
      
      CSV.open artists_path, 'wb' do |csv|
        csv << []
        artists.each do |artist|
          csv << create_row(artist)
        end
      end

      CSV.open releases_path, 'wb' do |csv|
        csv << []
        releases.each do |release|
          csv << create_row(release)
        end
      end
      
      sales_periods.each do |period|
        CSV.open sales_period_path(period), 'wb' do |csv|
          csv << []
          period.revenue_tallies.each do |tally|
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
      LabelReporter.config
    end

    def create_artist(row)      
      Artist.new hash_from_row row,
        primary_alias: :string,
        real_name: :string
    end
    
    def create_release(row)
      
      release = Release.new hash_from_row row,
        catalogue_number: :string,
        artist: :artist, # Artist name
        title: :string,
        release_date: :date,
        mastering_cost: :decimal,
        artwork_cost: :decimal,
        distribution_cost: :decimal,
        promotion_cost: :decimal,
        artist_split: :decimal,
        recoup_costs_before_split: :boolean
        
      release.artist.releases << release
      release
    end
    
    def create_revenue_tally(row, sales_period) 
      tally = RevenueTally.new hash_from_row row,
        release: :release,
        sales_revenue: :decimal,
        licensing_revenue: :decimal,
        ongoing_costs: :decimal,
        comment: :string
        
      # tally.release = find_release row[0] # Release catalogue number
      tally.sales_period = sales_period
      tally.release.revenue_tallies << tally
      sales_period.revenue_tallies << tally
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
          thing.artwork_cost,
          thing.distribution_cost,
          thing.promotion_cost,
          thing.artist_split,
          thing.recoup_costs_before_split ]
      when RevenueTally
        [ thing.release.catalogue_number,
          thing.sales_revenue,
          thing.licensing_revenue,
          thing.ongoing_costs,
          thing.comment ]
      else
        raise "Unknown entity: #{thing}"
      end
    end

    def data_path(clazz)
      "#{config.data_path}/#{clazz.name.pluralize.underscore}.csv" 
    end
    
    def sales_period_path(sales_period)
      date_str = sales_period.ends_at.strftime('%Y%m%d')
      "#{config.data_path}/sales_#{date_str}.csv"
    end
    
    def sales_period_paths
      Dir["#{config.data_path}/sales_*.csv"].select do |path|
        path =~ /sales_\d{8}\.csv$/ 
      end
    end

    def hash_from_row(row, key_types)
      hash = {}

      key_types.to_a.each_with_index do |key_type, i|
        key, type = key_type
        raw_value = row[i]
        
        if raw_value.present?
          hash[key] = case type
          when :artist
            find_artist raw_value
          when :release
            find_release raw_value
          when :string
            raw_value
          when :date
            Date.parse(raw_value)
          when :decimal
            BigDecimal.new(raw_value)
          when :boolean
            raw_value =~ /^true$/i
          else 
            raise "Invalid type: #{type}"
          end
        end
      end

      hash
    end

    def releases_path
      data_path Release
    end

  end
end

DataStore.reset