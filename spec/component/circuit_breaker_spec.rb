require 'circuit_breaker'
require 'timecop'
require 'spec_helper'

describe CircuitBreaker do
  MockResource = Struct.new(:name)

  let(:mock_resource) {MockResource.new('mock_resource')}

  def trigger_exceptions(iterations)
    exceptions = []
    iterations.times do
      begin
        yield
      rescue => e
        exceptions << e
      end
    end

    exceptions
  end

  it 'fails fast after 4 exceptions within time range' do
    circuit = described_class.new(resource: mock_resource, failure_threshold: 3, retry_timeout: 10)

    exceptions = trigger_exceptions(4) do
      circuit.foo
    end

    expect("NoMethodError: undefined method `foo'").
      to have_been_raised_the_first(3).times_in(exceptions)

    expect("CircuitBreakerOpenError").
      to have_been_raised_last_in(exceptions)
  end

  it 'resets after 10 seconds' do
    circuit = described_class.new(resource: mock_resource, failure_threshold: 3, retry_timeout: 10)

    exceptions = trigger_exceptions(4) do
      circuit.foo
    end

    expect("CircuitBreakerOpenError").
      to have_been_raised_last_in(exceptions)

    Timecop.travel(Time.now + 10)

    exceptions = trigger_exceptions(1) do
      circuit.foo
    end

    expect("NoMethodError: undefined method `foo'").
      to have_been_raised_last_in(exceptions)
  end
end
