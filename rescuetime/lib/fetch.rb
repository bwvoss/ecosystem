require 'chocolate_shell'
require 'time'
require 'httparty'
require 'active_support/core_ext/time/calculations.rb'

module Rescuetime
  class Fetch
    def parse_date(time)
      Time.parse(time).strftime('%Y-%m-%d')
    end

    def build_url(date)
      "#{ENV.fetch('RESCUETIME_API_URL')}?"\
      "key=#{ENV.fetch('RESCUETIME_API_KEY')}&"\
      "restrict_begin=#{date}&"\
      "restrict_end=#{date}&"\
      'perspective=interval&'\
      'resolution_time=minute&'\
      'format=json'
    end

    def request(url)
      timeout = ENV.fetch('HTTP_TIMEOUT_THRESHOLD').to_f
      r = HTTParty.get(url, timeout: timeout)
      { response: r, code: r.code }
    end

    def fetch_rows(response_hash)
      response_hash[:response].fetch('rows')
    end

    def parse_rows(rows)
      rows.map do |row|
        {
          date:                  row[0],
          time_spent_in_seconds: row[1],
          number_of_people:      row[2],
          activity:              row[3],
          category:              row[4],
          productivity:          row[5]
        }
      end
    end

    def convert_date_to_utc(rows)
      timezone = ENV.fetch('TIMEZONE')
      rows.each do |row|
        row[:date] = ActiveSupport::TimeZone[timezone]
                     .parse(row[:date])
                     .utc
                     .to_s
      end
    end

    include ChocolateShell::Boundary
  end
end
