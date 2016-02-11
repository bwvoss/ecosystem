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
    dates = [
      Time.parse('2015-10-23').utc,
      Time.parse('2015-10-24').utc,
      Time.parse('2015-10-25').utc,
      Time.parse('2015-10-26').utc,
      Time.parse('2015-10-27').utc,
      Time.parse('2015-10-28').utc,
      Time.parse('2015-10-29').utc,
      Time.parse('2015-10-30').utc,
      Time.parse('2015-10-31').utc
    ]

    dates.each do |date|
      run_uuid = SecureRandom.uuid
      p "run uuid is: #{run_uuid}"

      Rescuetime::SingleDaySync.call(
        db: DB,
        table: :rescuetime_interval,
        http: HTTParty,
        metric_receiver: Metric::Receivers::Rds.new(DB),
        run_uuid: run_uuid,
        api_domain: 'https://www.rescuetime.com/anapi/data',
        api_key: configs['rescuetime_api_key'],
        datetime: date,
        timezone: 'America/Chicago'
      )
    end
  end
end

task :collectd do
  system('sudo collectd -f -C collectd.conf')
end

task :parse_collectd do
  require 'metric/collectors/collectd_csv'
  system('sudo chown -R benvoss:staff csv/')

  # TODO: Fill in the csv path manually
  collector = Metric::Collectors::CollectdCsv.new(
    DB[:system_metric],
    'csv/bens-macbook-pro.local/cpu/percent-active-2016-02-05')
  collector.call
end

task :spec do
  system('bundle exec rspec')
end

task :lint do
  system('bundle exec rubocop')
end

task :flog do
  require 'flog_score'
  p 'Running Flog Checks....'

  flog = FlogScore.new('lib')
  threshold_breached = flog.per_class.any? do |item|
    item[:score] > 33
  end

  if threshold_breached
    fail 'flog threshold breached'
  else
    p 'Flog score threshold ok!'
  end
end

task :update_audit_data do
  system('bundle exec bundle-audit update')
end

task :audit_gems do
  system('bundle exec bundle-audit')
end

task default: %w(spec lint audit_gems flog)

task :service_double do
  system('cd lib/service_double/ && rackup config.ru')
end

task :metric_server do
  system('cd lib/metric/ && rackup config.ru -p 8000')
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

