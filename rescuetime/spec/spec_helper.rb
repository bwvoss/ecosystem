require 'http_test_harness'

module TestData
  module RescuetimeResponse
    def self.headers
      [
        'Date',
        'Time Spent (seconds)',
        'Number of People',
        'Activity',
        'Category',
        'Productivity'
      ]
    end

    def self.rows
      [
        ['2015-10-02T08:35:00', 105, 1, 'Terminal', 'Systems Operations', 2],
        ['2015-10-02T08:35:00', 54, 1, 'slack.com', 'Instant Message', -1],
        ['2015-10-02T08:35:00', 10, 1, 'logswan.org', 'Uncategorized', 0],
        ['2015-10-02T08:35:00', 1, 1, 'linuxfoundation.org', 'Search', 0],
        ['2015-10-02T08:35:00', 1, 1, 'Gmail', 'Email', 0]
      ]
    end
  end
end

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

  HttpTestHarness.set(
    { path: "/rescuetime#{querystring}" }.merge(config)
  )
end

require 'rescuetime/fetch'
require 'rescuetime/fetch_handler'

def run_rescuetime
  ENV['RESCUETIME_API_URL'] = "#{HttpTestHarness::BASE_URL}/rescuetime"
  ENV['RESCUETIME_API_KEY'] = 'some-test-credential'
  ENV['HTTP_TIMEOUT_THRESHOLD'] ||= '5'
  ENV['TIMEZONE'] = 'America/Chicago'
  Rescuetime::Fetch.new('2015-10-02')
                   .parse_date
                   .build_url
                   .request
                   .fetch_rows
                   .parse_rows
                   .convert_date_to_utc
                   .on_error(Rescuetime::FetchHandler)
end

