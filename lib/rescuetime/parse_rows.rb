require 'light-service'

module Rescuetime
  class ParseRows
    extend LightService::Action
    expects :get_response
    promises :parsed_rescuetime_rows

    executed do |ctx|
      rows = ctx.get_response["rows"]
      parsed_rows = rows.map do |row|
        {
          date:                  row[0],
          time_spent_in_seconds: row[1],
          number_of_people:      row[2],
          activity:              row[3],
          category:              row[4],
          productivity:          row[5]
        }
      end

      ctx.parsed_rescuetime_rows = parsed_rows
    end
  end
end

