require 'datastore/connection'
require 'yaml'
require 'database_cleaner'

configs = YAML.load_file('configuration.yml')['test']
DB = Datastore::Connection.new(configs['db_connection_string']).call

RSpec.configure do |config|
  config.before(:suite) do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'migrations')

    DatabaseCleaner[:sequel, { connection: DB }]
    DatabaseCleaner.strategy = :transaction
  end

  # integration tests dont play nicely with transaction cleaning
  config.before(:all, :truncate) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:all, :truncate) do
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    services = example.metadata.fetch(:services, [])
    if services.include?(:rds)
      DatabaseCleaner.cleaning do
        example.run
      end
    else
      example.run
    end
  end
end

