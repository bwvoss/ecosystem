require 'rescuetime/build_url'
require 'time'
require 'cgi'
require 'uri'

describe Rescuetime::BuildUrl do
  let(:api_key)  { '53gbkdsfg9s7nd' }
  let(:datetime) { Time.parse('2015-1-3') }
  let(:http)     { double(:get) }

  context 'fetches rescuetime data with:' do
    def querystring_value_for(key, url)
      CGI.parse(URI.parse(url).query)[key][0]
    end

    let(:get_url) do
      result = described_class.execute(
        api_domain: 'http://www.example.com',
        api_key: api_key,
        datetime: datetime
      )

      result.fetch(:get_url)
    end

    it 'api key' do
      ENV['RESCUETIME_API_KEY'] = api_key
      expect(querystring_value_for('key', get_url))
        .to eq(api_key)
    end

    it 'begin date formatted in YYYY-MM-DD' do
      expect(querystring_value_for('restrict_begin', get_url))
        .to eq('2015-01-03')
    end

    it 'end date formatted in YYYY-MM-DD' do
      expect(querystring_value_for('restrict_end', get_url))
        .to eq('2015-01-03')
    end

    it 'intervals metrics' do
      expect(querystring_value_for('perspective', get_url))
        .to eq('interval')
    end

    it 'broken down on a minute basis' do
      expect(querystring_value_for('resolution_time', get_url))
        .to eq('minute')
    end

    it 'requesting a JSON response' do
      expect(querystring_value_for('format', get_url))
        .to eq('json')
    end
  end
end

