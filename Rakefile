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

namespace :system_metrics do
  require 'poll'

  task :poll do
    require 'metric/cpu'
    metric_receiver = Metric::Receivers::Rds.new(DB)
    cpu = Metric::Cpu.new

    Poll.new(1) do
      metric_receiver << {
        type: 'system',
        cpu_percentage_used: cpu.percentage_used,
        top_cpu_processes: cpu.top_processes
      }
    end.start
  end
end

namespace :monitors do
  task :cpu_percentage do
  end

  task :action_duration do
  end

  task :full_run_duration do
  end
end

namespace :test do
  task :default do
    system('bundle exec rspec && bundle exec rubocop')
  end

  task :gem_vulns do
    system('bundle exec bundle-audit update && bundle exec bundle-audit')
  end
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

