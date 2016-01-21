$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'timers'
require 'metric/receivers/rds'
require 'metric/cpu'

namespace :system_metrics do
  task :poll do
    timers = Timers::Group.new
    metric_receiver = Metric::Receivers::Rds.new(db[:system_metric])
    cpu = Metric::Cpu.new

    record_system_metrics = timers.every(5) do
      metric_receiver << {
        type: 'system',
        cpu_used: cpu.used,
        cpu_idle: cpu.idle
      }
    end

    loop do
      record_system_metrics.wait
    end
  end
end

task :test do
  system('bundle exec rspec && bundle exec rubocop')
end

task :gem_audit do
  system('bundle exec bundle-audit update && bundle exec bundle-audit')
end

namespace :db do
  task :reset do
    system('dropdb -U postgres -h localhost -p 2200 postgres')
    system('createdb -U postgres -h localhost -p 2200 postgres')
  end
end

namespace :services do
  namespace :postgresql do
    task :up do
      system('cd infrastructure/postgresql && vagrant up')
    end

    task :down do
      system('cd infrastructure/postgresql && vagrant halt')
    end
  end

  namespace :proxy_server do
    task :up do
      system('cd service_proxy && rackup config.ru')
    end
  end
end

