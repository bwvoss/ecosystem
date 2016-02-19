require 'light-service'
require 'active_support/core_ext/time/calculations.rb'

module Rescuetime
  class ParseDateToUtc
    extend LightService::Action
    expects :parsed_rescuetime_rows, :timezone
    promises :converted_rescuetime_rows

    executed do |ctx|
      converted_rows = ctx.parsed_rescuetime_rows.map do |row|
        date = row.fetch(:date)
        date_to_utc = ActiveSupport::TimeZone[ctx.timezone].parse(date).utc.to_s
        row.merge(date: date_to_utc)
      end

      ctx.converted_rescuetime_rows = converted_rows
    end
  end
end

