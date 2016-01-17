RSpec.configure do |config|
  class TestDependencyServiceError < StandardError; end

  config.before(:all, services: [:postgresql]) do
    require 'database_cleaner'
    @connection_string = 'postgres://postgres@localhost:2200/postgres'
    @db = Sequel.connect(@connection_string)
    Sequel.extension :migration
    Sequel::Migrator.run(@db, "migrations")
  end

  config.around(:each) do |example|
    services = example.metadata[:services]
    if services && services.include?(:postgresql)
      require 'database_cleaner'
      DatabaseCleaner[:sequel, {connection: @db}]
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.cleaning do
        example.run
      end
    else
      example.run
    end
  end
end

RSpec::Matchers.define :have_been_raised_last_in do |exceptions|
  match do |actual|
    exceptions.last.inspect.include?(actual)
  end
end

RSpec::Matchers.define :have_been_raised_the_first do |count|
  match do |actual|
    @exceptions[0...count].all?{|e| e.inspect.include?(actual)}
  end

  chain :times_in do |exceptions|
    @exceptions = exceptions
  end
end

def assert_timeout(exception:)
  rescued = false
  begin
    yield
  rescue => e
    rescued = true
    expect(e.inspect).to include(exception)
  ensure
    expect(rescued).to be_truthy, "No exception was thrown!"
  end
end

def assert_threaded_timeout(threads:, exception:)
  threads = []
  6.times do |i|
    threads << Thread.new { yield }
  end

  assert_timeout(exception: exception) do
    threads.each(&:join)
  end
end

