class Spinach::Features::HistoricalReports < Spinach::FeatureSteps
  include Reporting

  step 'the only artist on my books is DJ Doo Doo' do
    @artist = Artist.new primary_alias: 'DJ Doo Doo'
  end

  step 'his real name is Tarquin Whiteboy' do
    @artist.real_name = 'Tarquin Whiteboy'
  end

  step 'his only release, \'Wubz 4 Eva\' was published six months ago' do
    @release = Release.new title: 'Wubz 4 Eva', release_date: 6.months.ago
  end

  step 'it cost $200 in total to produce' do
    pending 'step not implemented'
  end

  step 'we have agreed to split revenue evenly after profits' do
    pending 'step not implemented'
  end

  step 'this is the first time I am doing a report' do
    pending 'step not implemented'
  end

  step 'the release has made $50' do
    pending 'step not implemented'
  end

  step 'I have all this info in spreadsheets' do
    pending 'step not implemented'
  end

  step 'I generate the report' do
    pending 'step not implemented'
  end

  step 'it should greet him as Dear Mr Whiteboy' do
    pending 'step not implemented'
  end

  step 'it should show that he is entitled to nothing' do
    pending 'step not implemented'
  end

  step 'it should show that $150 is still to go before we break even' do
    pending 'step not implemented'
  end
end
