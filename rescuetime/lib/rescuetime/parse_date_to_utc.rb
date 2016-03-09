require 'active_support/core_ext/time/calculations.rb'

module Rescuetime
  class ParseDateToUtc
    def self.execute(ctx)
      converted_rows = ctx.fetch(:parsed_rescuetime_rows).map do |row|
        date = row.fetch(:date)
        timezone = ENV['TIMEZONE']
        date_to_utc = ActiveSupport::TimeZone[timezone].parse(date).utc.to_s
        row.merge(date: date_to_utc)
      end

      ctx[:rescuetime_rows] = converted_rows

      ctx
    end
  end
end

