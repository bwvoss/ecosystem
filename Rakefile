require "sequel"
$:<< File.join(File.dirname(__FILE__), 'lib')

task :test do
  #TODO: combine flog, rubocop and rspec
end

namespace :foreman do
  task :test do
    system('foreman start -f Procfile.test')
  end
end

namespace :services do
  namespace :postgresql do
    task :up do
      system("cd infrastructure/postgresql && vagrant up")
    end

    task :down do
      system("cd infrastructure/postgresql && vagrant halt")
    end
  end

  namespace :proxy_server do
    task :up do
      system("cd service_proxy && ruby service_proxy.rb")
    end
  end
end

namespace :db do
  task :migrate do |t, args|
    connection_string = args[:connection_string] || ENV.fetch("CONNECTION_STRING")
    Sequel.extension :migration
    db = Sequel.connect(connection_string)

    Sequel::Migrator.run(db, "migrations")
  end
end

