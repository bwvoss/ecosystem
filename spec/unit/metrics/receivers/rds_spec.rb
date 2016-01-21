require 'metrics/receivers/rds'

describe Metrics::Receivers::Rds do
  let(:mock_db) { { duration_metric: [] } }

  it 'removes type from the event and saves it in the right table' do
    receiver = described_class.new(mock_db)
    event = {
      type: :duration,
      duration: 1,
      host: 'my-host',
      time: '11-03-2015'
    }

    receiver << event

    expect(mock_db[:duration_metric].first).to eq(
      duration: 1,
      host: 'my-host',
      time: '11-03-2015'
    )
  end

  context 'adds the following by default:' do
    def metric(key)
      mock_db[:duration_metric].first.fetch(key)
    end

    specify 'host' do
      expect(Socket).to receive(:gethostname) { 'mocked-host' }
      receiver = described_class.new(mock_db)

      event = {
        type: :duration,
        duration: 1,
        time: '11-03-2015'
      }

      receiver << event

      expect(metric(:host)).to eq('mocked-host')
    end

    specify 'time in utc' do
      receiver = described_class.new(mock_db)

      event = {
        type: :duration,
        duration: 1
      }

      receiver << event

      expect(metric(:time).utc?).to be_truthy
    end
  end
end

