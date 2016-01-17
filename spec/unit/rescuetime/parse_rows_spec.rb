require 'rescuetime/parse_rows'

describe Rescuetime::ParseRows do
  let(:response) do
    {
      'rows' => [
        ['2015-08-03T08:00:00',
         519,
         1,
         'unixgeeks.org',
         'General Reference & Learning',
         3]
      ]
    }
  end

  let(:parsed_rows) do
    result = described_class.execute(get_response: response)
    result.parsed_rescuetime_rows
  end

  context 'returns the following data per event:' do
    specify 'number of people' do
      expect(parsed_rows.first[:number_of_people]).to eq(1)
    end

    specify 'productivity' do
      expect(parsed_rows.first[:productivity]).to eq(3)
    end

    specify 'activity' do
      expect(parsed_rows.first[:activity]).to eq('unixgeeks.org')
    end

    specify 'category' do
      expect(parsed_rows.first[:category]).to eq('General Reference & Learning')
    end

    specify 'time_spent_in_seconds' do
      expect(parsed_rows.first[:time_spent_in_seconds]).to eq(519)
    end

    specify 'date' do
      expect(parsed_rows.first[:date]).to eq('2015-08-03T08:00:00')
    end
  end
end

