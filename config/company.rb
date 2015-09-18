require 'ostruct'
require 'yaml'

COMPANY = OpenStruct.new YAML.load_file('./config/company.yaml')