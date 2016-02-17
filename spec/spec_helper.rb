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
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

def utc_date(date_string)
  Time.parse(date_string).utc
end

require 'service_double/service_double'
require 'test_data/rescuetime_response'

def rescuetime_config
  {
    response: {
      row_headers: TestData::RescuetimeResponse.headers,
      rows: TestData::RescuetimeResponse.rows
    }
  }
end

def configure_rescuetime_response(config = rescuetime_config)
  querystring = '?key=some-test-credential&restrict_begin=2015-10-02'\
                '&restrict_end=2015-10-02&perspective=interval'\
                '&resolution_time=minute&format=json'

  ServiceDouble.set(
    { path: "/rescuetime#{querystring}" }.merge(config)
  )
end

require 'rescuetime/run'
def run_rescuetime
  Rescuetime::Run.call(
    run_uuid: 'lsdkfj278',
    api_domain: "#{ServiceDouble::BASE_URL}/rescuetime",
    api_key: 'some-test-credential',
    datetime: utc_date('2015-10-02')
  )
end

