require 'sequel'
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

task :test do
  system('bundle exec rspec && bundle exec rubocop')
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

