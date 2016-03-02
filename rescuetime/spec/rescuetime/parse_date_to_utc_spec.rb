require 'rescuetime/parse_date_to_utc'

describe Rescuetime::ParseDateToUtc do
  it 'transforms the date from the timezone to utc for each item' do
    timezone = 'America/Chicago'
    original_date = '2015-08-03T08:00:00'
    parsed_rows = [{
      date: original_date
    }]

    result = described_class.execute(
      parsed_rescuetime_rows: parsed_rows,
      timezone: timezone
    )
    transformed_rows = result.fetch(:rescuetime_rows)

    expect(transformed_rows.first[:date]).not_to eq(original_date)
  end
end

