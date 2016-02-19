$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'yaml'

namespace :rescuetime do
  require 'rescuetime/run'
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

task default: %w(spec lint audit_gems)

task :service_double do
  system('cd lib/service_double/ && rackup config.ru')
end

