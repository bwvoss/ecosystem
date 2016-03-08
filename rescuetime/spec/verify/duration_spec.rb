require 'verify/duration'

describe Verify::Duration do
  let(:mock_context) do
    {
      run_uuid: 'run_uuid',
      metric_collector: []
    }
  end

  let(:observation) do
    described_class.call(Class, mock_context) do
      mock_context[:result] = 2 + 2

      mock_context
    end
  end

  it 'executes the given block and returns the result' do
    expect(observation.fetch(:result)).to eq(4)
  end

  it 'adds the duration metric' do
    observation.fetch(:result)

    metric = mock_context.fetch(:metric_collector).first
    expect(metric[:action]).to eq('Class')
    expect(metric[:run_uuid]).to eq('run_uuid')
    expect(metric[:duration]).not_to be_nil
    expect(metric[:type]).to eq('duration')
  end
end
