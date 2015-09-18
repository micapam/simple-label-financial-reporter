require 'optparse'

module LabelReporter
  class Cli
    def initialize(args = ARGV)
      @args = args
    end

    def run
      options
      Reporter.work
      exit 0
    end

    def options
      @options ||= parse_options
    end

    private

    def parse_options
      config = {}

      begin
        OptionParser.new do |opts|
          opts.on('-c', '--company_config FILE_PATH',
              'Use a custom company configuration file') do |file|
            LabelReporter.config.company_config_file = file
          end

          opts.on('-d', '--data_path PATH',
              'Use a custom data path') do |path|
            LabelReporter.config.data_path = path
          end

          opts.on('-d', '--output_format FORMAT',
              'Data format for output (pdf, html; default pdf)') do |format|
            LabelReporter.config.output_format = format
          end

          opts.on('-d', '--output_path PATH',
              'Use a custom output path') do |path|
            LabelReporter.config.output_path = path
          end

          opts.on('-d', '--until_date PATH',
              'Ignore all sales periods beyond a given date') do |date|
            LabelReporter.config.until_date = Date.parse(date)
          end
        end.parse!(@args)
      rescue OptionParser::ParseError => exception
        fail! exception.message.capitalize
      end
    end

    def fail!(message=nil)
      puts message if message
      exit 1
    end
    
    #TODO redundant?
    def reporter_class(klass)
      # "Spinach::Reporter::" + Spinach::Support.camelize(klass)
    end
  end
end
