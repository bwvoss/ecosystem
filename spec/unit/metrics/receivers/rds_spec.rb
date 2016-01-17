require 'metrics/receivers/rds'

describe Metrics::Receivers::Rds do
  it 'removes type from the event and saves it in the right table' do
    mock_db = {
      duration_metric: []
    }

    receiver = described_class.new(mock_db)
    event = {
      type: :duration,
      duration: 1
    }

    receiver << event

    expect(mock_db[:duration_metric]).to eq([event])
  end
end

