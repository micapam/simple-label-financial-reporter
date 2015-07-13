ENV['RAILS_ENV'] = 'test'

require 'rspec'

Dir['./app/**/*.rb'].each {|file| require file }


