RSpec.configure do |config|
  class TestDependencyServiceError < StandardError; end

  config.before(:all, services: [:postgresql]) do
    require 'database_cleaner'
    @connection_string = 'postgres://postgres@localhost:2200/postgres'
    @db = Sequel.connect(@connection_string)
    Sequel.extension :migration
    Sequel::Migrator.run(@db, 'migrations')
  end

  config.around(:each) do |example|
    services = example.metadata[:services]
    if services && services.include?(:postgresql)
      require 'database_cleaner'
      DatabaseCleaner[:sequel, { connection: @db }]
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.cleaning do
        example.run
      end
    else
      example.run
    end
  end
end

