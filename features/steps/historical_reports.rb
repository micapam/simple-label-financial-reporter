class Spinach::Features::HistoricalReports < Spinach::FeatureSteps
  include Reporting

  step 'the only artist on my books is DJ Doo Doo' do
    @artist = Artist.new primary_alias: 'DJ Doo Doo'
  end

  step 'his real name is Tarquin Whiteboy' do
    @artist.real_name = 'Tarquin Whiteboy'
  end

  step 'his only release, \'Wubz 4 Eva\' was published six months ago' do
    @release = Release.new title: 'Wubz 4 Eva', release_date: 4.months.ago,
      artist: @artist
  end
  
  step 'it cost $100 for mastering' do
    @release.mastering_cost = 100.0
  end
  
  step 'it cost $50 for cover art' do
    @release.artwork_cost = 50.0
  end
  
  step 'it cost $20 for digital distribution' do
    @release.distribution_cost = 20.0
  end
  
  step 'it cost $200 for promotion' do
    @release.promotion_cost = 200.0
  end
 
  step 'we have agreed to split revenue evenly after costs' do
    @release.artist_split = 0.5
    @release.recoup_costs_before_split = true
  end

  step 'this is the first time I am doing a report' do
    # This is the default state of a release
  end

  step 'it has taken $300 in sales' do
    @release.sales_periods << SalesPeriod.new(begins_at: 6.months.ago,
      ends_at: Time.now, revenue: 300.0)
  end

  step 'I have all this info in spreadsheets' do
    DataStore.artists << artist
    DataStore.save!

    # Ensure data is taken from saved spreadsheets and not just
    # persisted in memory
    DataStore.reset 
  end

  step 'I generate the report' do
    Reporter.generate
    @report = Reporter.reports.first 
  end

  step 'it should greet him as Dear Mr Whiteboy' do
    expect(@report.body).to match /Dear Mr Whiteboy/
  end

  step 'it should show that he is entitled to nothing' do
    expect(@report.body).to match /no funds are to be dispatched at this time/
  end

  step 'it should show that $150 is still to go before we break even' do
    expect(@report.body).to match /Net balance: -150.00/
  end
end
