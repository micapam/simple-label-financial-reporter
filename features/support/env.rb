ENV['RAILS_ENV'] = 'test'

require 'rspec'
require './config/company'
require 'spinach/frameworks/rspec'

%w(lib app).each do |dir|
  Dir["./#{dir}/**/*.rb"].each do |file|
    require file
  end
end

DataStore.configure do |config|
  config.data_location = 'data/test'
end