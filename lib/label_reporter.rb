require 'active_support'
require 'active_support/core_ext'
require_relative '../config/company'

module LabelReporter
end

%w(lib app).each do |dir|
  Dir["./#{dir}/**/*.rb"].each do |file|
    require file
  end
end