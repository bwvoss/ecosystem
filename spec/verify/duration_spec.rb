require 'verify/duration'

describe Verify::Duration do
  let(:mock_context) do
    { run_uuid: 'run_uuid' }
  end

  let(:observe) do
    described_class.call(Class, mock_context) do
      2 + 2
    end
  end

  it 'executes the given block and returns the result' do
    result, _metric = observe

    expect(result).to eq(4)
  end

  it 'returns the duration metric' do
    _result, metric = observe

    expect(metric[:time]).to be_utc
    expect(metric[:action]).to eq('Class')
    expect(metric[:run_uuid]).to eq('run_uuid')
    expect(metric[:duration]).not_to be_nil
    expect(metric[:type]).to eq('duration')
  end
end

