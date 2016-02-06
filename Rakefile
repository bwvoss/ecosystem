$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'datastore/connection'
require 'yaml'
require 'metric/receivers/rds'

configs = YAML.load_file('configuration.yml')['development']
DB = Datastore::Connection.new(configs['db_connection_string']).call

namespace :rescuetime do
  require 'rescuetime/single_day_sync'
  require 'httparty'
  require 'securerandom'

  task :sync do
    utc_date = Time.parse('2015-10-23').utc
    Rescuetime::SingleDaySync.call(
      db: DB,
      table: :rescuetime_interval,
      http: HTTParty,
      metric_receiver: Metric::Receivers::Rds.new(DB),
      run_uuid: SecureRandom.uuid,
      api_domain: 'https://www.rescuetime.com/anapi/data',
      api_key: configs['rescuetime_api_key'],
      datetime: utc_date,
      timezone: 'America/Chicago'
    )
  end
end

task :collectd do
  system('sudo collectd -f -C collectd.conf')
end

task :spec do
  system('bundle exec rspec')
end

task :lint do
  system('bundle exec rubocop')
end

task :update_audit_data do
  system('bundle exec bundle-audit update')
end

task :audit_gems do
  system('bundle exec bundle-audit')
end

task default: %w(spec lint audit_gems)

task :service_double do
  system('cd lib/service_double/ && rackup config.ru')
end

namespace :db do
  task :migrate do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'migrations')
  end

  task :reset do
    # system('dropdb -U postgres -h localhost -p 2200 postgres')
    # system('createdb -U postgres -h localhost -p 2200 postgres')

    system('dropdb postgres')
    system('createdb postgres')
  end
end

