require 'pdfkit'

class Reporter
  class << self

    def generate
      DataStore.load
      
      DataStore.artists.each do |artist|
        reports << Report.new(artist, latest_sales_period)
      end
    end
    
    def latest_sales_period
      DataStore.latest_sales_period
    end

    def reports
      @reports ||= []
    end
    
    def write
      date = latest_sales_period.ends_at.strftime('%d%m%Y')
      puts "Writing reports for period ending #{date}:"
      
      reports.each do |report|
        report.render
        artist_name = report.artist.primary_alias
      
        only_artist = LabelReporter.config.only_artist
        next if only_artist.present? && only_artist != artist_name
        
        safe_artist_name = artist_name.parameterize.gsub '-', '_'
        file_name = "#{safe_artist_name.underscore}_#{date}"
        path = "#{LabelReporter.config.output_path}/#{file_name}"
        puts "Writing report for artist: #{artist_name}..."
        
        case LabelReporter.config.output_format
        when 'pdf'
          kit = PDFKit.new report.content, page_size: 'Letter'
          kit.to_file "#{path}.pdf"
        when 'html'
          File.write "#{path}.html", report.content
        else 
          raise "Unknown output format: #{LabelReport.config.output_format}"
        end
      end
      
      puts "Done."
    end
    
    def work
      generate 
      write
    end

  end
end