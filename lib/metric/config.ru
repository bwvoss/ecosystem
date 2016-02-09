require 'sequel'
require 'yaml'
require_relative 'server'

configs = YAML.load_file('../../configuration.yml')['development']
DB = Sequel.connect(configs['db_connection_string'])
run Metric::Server
