require 'metric/collectors/duration'

describe Metric::Collectors::Duration do
  let(:metric_receiver) { [] }
  let(:service) { :test_service }
  let(:run_uuid) { '1jksdfij5' }
  let(:context) { { run_uuid: run_uuid } }
  let(:action) { Class }

  it 'executes the given block and returns the result' do
    observer = described_class.new(metric_receiver, :test_service)

    result = observer.call(action, context) do
      2 + 2
    end

    expect(result).to eq(4)
  end

  context 'sends the following items to the metric store:' do
    def metric(key)
      observer = described_class.new(metric_receiver, :test_service)

      observer.call(action, context) {}

      metric_receiver.first[key]
    end

    specify 'action as a string' do
      expect(metric(:action)).to eq('Class')
    end

    specify 'duration' do
      expect(metric(:duration)).not_to be_nil
    end

    specify 'run_uuid' do
      expect(metric(:run_uuid)).to eq(run_uuid)
    end

    specify 'service as a string' do
      expect(metric(:service)).to eq('test_service')
    end
  end
end

