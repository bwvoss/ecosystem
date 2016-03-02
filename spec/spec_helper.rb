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
  ENV['RESCUETIME_API_URL'] = "#{ServiceDouble::BASE_URL}/rescuetime"
  ENV['RESCUETIME_API_KEY'] = 'some-test-credential'
  Rescuetime::Run.call(
    run_uuid: 'lsdkfj278',
    datetime: Time.parse('2015-10-02').utc
  )
end

