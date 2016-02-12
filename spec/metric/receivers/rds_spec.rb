require 'metric/receivers/rds'
require 'spec_helper'

describe Metric::Receivers::Rds do
  it 'sends metrics to a relational database', services: [:rds] do
    receiver = described_class.new(DB)

    receiver << {
      type: :duration,
      host: 'test-host',
      duration: 23
    }

    persisted_metric = DB[:duration_metric].first
    expect(persisted_metric[:duration]).to eq(23)
    expect(persisted_metric[:host]).to eq('test-host')
    expect(persisted_metric.keys).not_to include('type')
  end

  context 'adds the following by default:' do
    let(:mock_db) { { duration_metric: [] } }

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

