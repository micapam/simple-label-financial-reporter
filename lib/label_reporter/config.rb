require "yaml"

module LabelReporter
  def self.config
    @config ||= Config.new
  end

  class Config
    attr_writer :company_config_file, :data_path, :output_format,
      :output_path, :until_date
    
    def company_config_file
      @company_config_file || './config/company.yaml'
    end
    
    def data_path
      @data_path || './data/real'
    end
    
    def output_format
      @output_format || 'pdf'
    end
    
    def output_path
      @output_path || './output'
    end
    
    def until_date
      @until_date || 1000.years.from_now
    end
  end
end
